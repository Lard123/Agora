//
//  AuctionVC.swift
//  Agora
//
//  Created by Varun Shenoy on 11/24/16.
//  Copyright © 2016 Varun Shenoy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class AuctionVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var items = [Item]()
    
    var ref: FIRDatabaseReference!
    
    var loadedOnce = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        collectionView.dataSource = self
        collectionView.delegate = self
        // Do any additional setup after loading the view.
        let screenWidth = UIScreen.main.bounds.size.width
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionView!.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: (screenWidth - 30)/2, height: 200)
        collectionView!.collectionViewLayout = layout
        collectionView!.backgroundColor = UIColor.clear
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !loadedOnce {
            self.beginLoading()
            getData()
            collectionView.alpha = 0
            //self.collectionView.reloadData()  
            UIView.animate(withDuration: 1, animations: {
                self.collectionView.alpha = 1
            })
            loadedOnce = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getData() {
        ref.child("items").observeSingleEvent(of: .value, with: { (snapshot) in
            self.items = []
            //self.beginLoading()
            if let json = snapshot.value as? [String : AnyObject] {
                for dict in json {
                    if let dict = dict.value as? [String : AnyObject] {
                        print(dict)
                        let currentBid = dict["bid"] as! String
                        let condition = dict["condition"] as! String
                        let description = dict["description"] as! String
                        let imageArray = dict["images"] as! [String: String]
                        let images = imageArray.values.reversed()
                        print(images)
                        let itemName = dict["name"] as! String
                        let sellerID = dict["sellerID"] as! String
                        let seller = dict["seller"] as! String
                        let i = Item(name: itemName, condition: condition, seller: seller, imageURLs: images, cost: Double(currentBid)!, sellerID: sellerID, description: description)
                        self.items.append(i)
                    }
                }
            }
            self.endLoading(vc: self, dismissVC: false)
            print(self.items.count)
            self.collectionView.reloadData()
        })
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath as IndexPath) as! ItemCell
        cell.setUpCell(obj: items[indexPath.row])
        return cell
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func base64ToImage(base64String: String) -> UIImage {
        let decodedData = NSData(base64Encoded: base64String, options: .ignoreUnknownCharacters)
        let decodedimage = UIImage(data: decodedData as! Data)
        return decodedimage!
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
