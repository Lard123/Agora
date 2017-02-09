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
    
    // outlets to user interface items in the view controller
    @IBOutlet weak var collectionView: UICollectionView!
    
    // array of items on auction
    var items = [Item]()
    
    var ref: FIRDatabaseReference!
    
    var loadedOnce = false
    
    var selectedItem: Item?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a reference to Firebase
        ref = FIRDatabase.database().reference()
        
        // connect the collectionView to code
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // customize the collectionView with dynamically sized cells and padding
        let screenWidth = UIScreen.main.bounds.size.width
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionView!.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: (screenWidth - 30)/2, height: 200)
        collectionView!.collectionViewLayout = layout
        collectionView!.backgroundColor = UIColor.clear
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !loadedOnce {
            
            //gather data from the auction
            self.beginLoading()
            getData()
            collectionView.alpha = 0
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
    
    // gather item information from Firebase, node by node
    func getData() {
        ref.child("items").observeSingleEvent(of: .value, with: { (snapshot) in
            self.items = []
            //self.beginLoading()
            if let json = snapshot.value as? [String : AnyObject] {
                for dict in json {
                    let key = dict.key
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
                        let sellerName = dict["seller"] as! String
                        let seller = User(sellerID: sellerID)
                        seller.name = sellerName
                        seller.getUserInfo()
                        let i = Item(name: itemName, condition: condition, seller: seller, imageURLs: images, cost: Double(currentBid)!, description: description, firebaseKey: key)
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
    
    // customize each cell on the auction
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath as IndexPath) as! ItemCell
        cell.setUpCell(obj: items[indexPath.row])
        return cell
    }
    
    // transition to ItemVC when an item is selected
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedItem = items[indexPath.row]
        performSegue(withIdentifier: "toItemDetail", sender: self)
    }
    
    // white status bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toItemDetail") {
            let auction = segue.destination as! ItemVC
            auction.item = selectedItem
        }
    }
    
    @IBAction func unwindToMarket(segue: UIStoryboardSegue) {}
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
