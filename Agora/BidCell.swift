//
//  BidCell.swift
//  Agora
//
//  Created by Varun Shenoy on 12/21/16.
//  Copyright © 2016 Varun Shenoy. All rights reserved.
//

import UIKit
import MessageUI
import Firebase
import FirebaseDatabase
import SwiftMessages

class BidCell: UITableViewCell {

    @IBOutlet weak var profileImage: CustomImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var bidAmountLabel: UILabel!
    
    var itemID = ""
    var bid: Bid!
    var vc: BidVC?
    var ref: FIRDatabaseReference!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUpCell(bid: Bid, vc: BidVC, itemID: String) {
        bid.getUserInfo(completionHandler: { (bool) in
            self.ref = FIRDatabase.database().reference()
            self.vc = vc
            self.bid = bid
            print("id: " + bid.userID)
            print("name: " + bid.name)
            print("email: " + bid.email)
            print("image: " + bid.pictureURL)
            
            self.itemID = itemID
            let price = bid.cost as NSNumber
            
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            
            self.bidAmountLabel.text = formatter.string(from: price)
            
            self.nameLabel.text = bid.name
            self.timeLabel.text = bid.timeStamp
            self.profileImage.loadImageUsingUrlString(urlString: bid.pictureURL)
            print("done")
        })
    }
    
    @IBAction func contactBidder(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Contact \(bid.name)", message: "How would you like to get in touch with the bidder on this item?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Email", style: .default, handler: {
            action in
            let mailVC = MFMailComposeViewController()
            mailVC.mailComposeDelegate = self.vc as MFMailComposeViewControllerDelegate?
            mailVC.setToRecipients([self.bid.email])
            
            self.vc?.present(mailVC, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Phone Call", style: .default, handler: {
            action in
            let url = NSURL(string: "telprompt://\(self.bid.phone)")!
            UIApplication.shared.openURL(url as URL)
        }))
        alert.addAction(UIAlertAction(title: "Text Message", style: .default, handler: {
            action in
            let messageVC = MFMessageComposeViewController()
            messageVC.messageComposeDelegate = self.vc as MFMessageComposeViewControllerDelegate?
            messageVC.recipients = [self.bid.phone]
            
            self.vc?.present(messageVC, animated: true, completion: nil)
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.popoverPresentationController?.sourceView = sender as? UIView
        alert.popoverPresentationController?.sourceRect = sender.bounds
        vc?.present(alert, animated: true, completion: nil)

    }
    
    @IBAction func sellItemOff(_ sender: AnyObject) {
        let itemRef = self.ref.child("items").child(self.itemID)
        itemRef.removeValue()
        increaseTotalFunded { (bool) in
            let view = MessageView.viewFromNib(layout: .CardView)
            view.button?.removeFromSuperview()
            
            view.configureTheme(.success)
            
            view.configureDropShadow()
            
            view.configureContent(title: "Item sold!", body: "Item has successfully been sold. Be sure to turn in the money to Mr. St. John in Room 914!")
            
            SwiftMessages.show(view: view)
            self.vc?.performSegue(withIdentifier: "toMarket", sender: self)
        }
    }
    
    func increaseTotalFunded(completionHandler:@escaping (Bool) -> ()) {
        ref.child("stats").observeSingleEvent(of: .value, with: { (snapshot) in
            //self.beginLoading()
            if let dict = snapshot.value as? [String : AnyObject] {
                print(dict)
                let currentAmount = dict["current"] as! Double
                let fullRef = self.ref.child("stats").child("current")
                fullRef.setValue(currentAmount + self.bid.cost)
                completionHandler(true)
            }
        })
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
