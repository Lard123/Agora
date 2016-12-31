//
//  UserVC.swift
//  Agora
//
//  Created by Varun Shenoy on 12/30/16.
//  Copyright © 2016 Varun Shenoy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class UserVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var imageView: CustomImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var items = [Item]()
    var itemsToFetch = [String]()
    
    var ref: FIRDatabaseReference!
    
    var selectedItem: Item?
    
    var loadedOnce = false
    var isCurrentUser = false
    var userID = ""
    var name = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        collectionView.delegate = self
        collectionView.dataSource = self

        let screenWidth = UIScreen.main.bounds.size.width
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionView!.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: (screenWidth - 30)/2, height: 200)
        collectionView!.collectionViewLayout = layout
        collectionView!.backgroundColor = UIColor.clear
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //self.beginLoading()
        //self.endLoading(vc: self, dismissVC: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !loadedOnce {
            imageView.layer.borderColor = UIColor.white.cgColor
            imageView.layer.borderWidth = 2
            if isCurrentUser {
                userID = (FIRAuth.auth()?.currentUser?.uid)!
                print(userID)
            }
            getUserInfo { (bool) in
                print("got info")
                self.getDataRefs(completionHandler: { (bool2) in
                    print("got refs")
                    for itemReference in self.itemsToFetch {
                        self.getDataForRef(node: itemReference)
                    }
                    print(self.items.count)
                    self.collectionView.reloadData()
                    self.collectionView.alpha = 0
                    UIView.animate(withDuration: 1, animations: {
                        self.collectionView.alpha = 1
                    })
                })
            }
            loadedOnce = true
        }
    }
    
    func getDataRefs(completionHandler:@escaping (Bool) -> ()) {
        print(userID)
        ref.child("users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild("items") {
                self.ref.child("users").child(self.userID).child("items").observeSingleEvent(of: .value, with: { (snapshot) in
                    self.items = []
                    self.itemsToFetch = []
                    if let json = snapshot.value as? [String : AnyObject] {
                        self.itemsToFetch = Array(json.keys)
                        print(self.itemsToFetch)
                    }
                    completionHandler(true)
                })
            }
            completionHandler(true)
        })
    }
    
    func getDataForRef(node: String) {
        ref.child("items").child(node).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dict = snapshot.value as? [String : AnyObject] {
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
                let i = Item(name: itemName, condition: condition, seller: seller, imageURLs: images, cost: Double(currentBid)!, description: description, firebaseKey: node)
                self.items.append(i)
                print("added!")
            }
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedItem = items[indexPath.row]
        performSegue(withIdentifier: "toItemDetailFromProfile", sender: self)
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //self.endLoading(vc: self, dismissVC: false)
        if (segue.identifier == "toItemDetailFromProfile") {
            let auction = segue.destination as! ItemVC
            //auction.transitioningDelegate = self
            //auction.modalPresentationStyle = .custom
            auction.item = selectedItem
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func getUserInfo(completionHandler:@escaping (Bool) -> ()) {
        let ref = FIRDatabase.database().reference()
        ref.child("users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let userDict = snapshot.value as? [String : AnyObject] {
                let name = userDict["name"] as! String
                self.nameLabel.text = name
                let pictureURL = userDict["image"] as! String
                self.imageView.loadImageUsingUrlString(urlString: pictureURL)
                let email = userDict["email"] as! String
                let phone = userDict["phone"] as! String
                completionHandler(true)
            }
        })
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
