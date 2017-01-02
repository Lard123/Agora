//
//  BidVC.swift
//  Agora
//
//  Created by Varun Shenoy on 12/21/16.
//  Copyright © 2016 Varun Shenoy. All rights reserved.
//

import UIKit
import MessageUI
import Firebase
import FirebaseDatabase

class BidVC: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    var bids = [Bid]()
    var item: Item!
    var ref: FIRDatabaseReference!
    var toUserVCID = ""
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        ref = FIRDatabase.database().reference()
        getBids()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bids.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bid", for: indexPath as IndexPath) as! BidCell
        cell.setUpCell(bid: bids[indexPath.row], vc: self, itemID: item.firebaseKey)
        return cell
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func getBids() {
        ref.child("items").child(item.firebaseKey).child("bids").observeSingleEvent(of: .value, with: { (snapshot) in
            //self.beginLoading()
            if let json = snapshot.value as? [String : AnyObject] {
                for dict in json {
                    if let dict = dict.value as? [String : AnyObject] {
                        print(dict)
                        let userID = dict["user"] as! String
                        let bidAmount = dict["bid"] as! String
                        let time = dict["time"] as! Double
                        let bid = Bid(cost: Double(bidAmount)!, userID: userID, timeStamp: time)
                        self.bids.append(bid)
                    }
                }
            }
            self.bids.sort(by: {$0.numericTimeStamp > $1.numericTimeStamp})
            self.tableView.reloadData()
        })
        
    }
    
    func toUserVC(id: String) {
        toUserVCID = id
        performSegue(withIdentifier: "offersToUser", sender: self)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMarket" {
            let vc = segue.destination as! AuctionVC
            vc.loadedOnce = false
        } else if segue.identifier == "offersToUser" {
            let vc = segue.destination as! UserVC
            vc.userID = toUserVCID
        }
    }

}
