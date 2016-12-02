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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        collectionView.dataSource = self
        collectionView.delegate = self
        self.beginLoading()
        //getData()
        let screenWidth = UIScreen.main.bounds.size.width
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionView!.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: (screenWidth - 30)/2, height: 200)
        collectionView!.collectionViewLayout = layout
        collectionView!.backgroundColor = UIColor.clear
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getData() {
        ref.child("items").observe(FIRDataEventType.value, with: { (snapshot) in
            if let json = snapshot.value as? [String : AnyObject] {
                for dict in json {
                    if let dict = dict.value as? [String : AnyObject] {
                        let currentBid = dict["bid"] as! String
                        let condition = dict["condition"] as! String
                        let description = dict["description"] as! String
                        let images = [#imageLiteral(resourceName: "dusty")]//dict["images"] as! [String: String]
                        let itemName = dict["name"] as! String
                        let sellerID = dict["sellerID"] as! String
                        let seller = dict["seller"] as! String
                        let i = Item(name: itemName, condition: condition, seller: seller, images: images, cost: Double(currentBid)!, sellerID: sellerID, description: description)
                        self.items.append(i)
                        /*var imageArray = [UIImage]()
                        for img in images {
                            imageArray.append(self.base64ToImage(base64String: img.value))
                        }*/
                    }
                }
            }
        })
        collectionView.reloadData()
        print(items.count)
        self.endLoading(vc: self, dismissVC: false)
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
