//
//  AuctionVC.swift
//  Agora
//
//  Created by Varun Shenoy on 11/24/16.
//  Copyright © 2016 Varun Shenoy. All rights reserved.
//

import UIKit

class AuctionVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var items = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        self.beginLoading()
        getData()
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
        var i = Item(name: "AP Chemistry Textbook", condition: "Pre-owned", owner: "Varun Shenoy", image: #imageLiteral(resourceName: "textbooks"), cost: 33)
        items.append(i)
        i = Item(name: "Pair of Winter Gloves", condition: "New with Tags", owner: "Naren Ramesh", image: #imageLiteral(resourceName: "gloves"), cost: 15)
        items.append(i)
        i = Item(name: "Bag of Cheetos", condition: "Slightly Used", owner: "Edward Hsu", image: #imageLiteral(resourceName: "cheetos"), cost: 120)
        items.append(i)
        i = Item(name: "Diamondback Road Bike", condition: "Pre-owned", owner: "Bhavesh Manivannan", image: #imageLiteral(resourceName: "bike"), cost: 76)
        items.append(i)
        i = Item(name: "Nintendo DS Game Cartridges", condition: "Slightly Used", owner: "Shreyas Patankar", image: #imageLiteral(resourceName: "game-pile"), cost: 24)
        items.append(i)
        i = Item(name: "AP Chemistry Textbook", condition: "Pre-owned", owner: "Varun Shenoy", image: #imageLiteral(resourceName: "textbooks"), cost: 33)
        items.append(i)
        i = Item(name: "Pair of Winter Gloves", condition: "New with Tags", owner: "Naren Ramesh", image: #imageLiteral(resourceName: "gloves"), cost: 15)
        items.append(i)
        i = Item(name: "Bag of Cheetos", condition: "Slightly Used", owner: "Edward Hsu", image: #imageLiteral(resourceName: "cheetos"), cost: 120)
        items.append(i)
        i = Item(name: "Diamondback Road Bike", condition: "Pre-owned", owner: "Bhavesh Manivannan", image: #imageLiteral(resourceName: "bike"), cost: 76)
        items.append(i)
        i = Item(name: "Nintendo DS Game Cartridges", condition: "Slightly Used", owner: "Shreyas Patankar", image: #imageLiteral(resourceName: "game-pile"), cost: 24)
        items.append(i)
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
