//
//  ActionCell.swift
//  Agora
//
//  Created by Varun Shenoy on 12/13/16.
//  Copyright © 2016 Varun Shenoy. All rights reserved.
//

import UIKit
import MessageUI
import Social

class ActionCell: UITableViewCell {
    
    // outlets to user interface items in the view controller
    @IBOutlet weak var offerButton: UIButton!
    
    @IBOutlet weak var contactButton: UIButton!
    
    @IBOutlet weak var shareItem: UIButton!
    
    var email = ""
    var phone = ""
    var owner = ""
    var itemName = ""
    var vc: UIViewController?
    
    func setUpCell(seller: User, itemName: String, vc: UIViewController) {
        self.email = seller.email
        self.phone = seller.phone
        self.owner = seller.name
        self.itemName = itemName
        self.vc = vc
    }
    
    // contact the seller with an email, a phone call, or a text message
    @IBAction func contactSeller(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Contact \(owner)", message: "How would you like to get in touch with the seller of this item?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Email", style: .default, handler: {
            action in
            let mailVC = MFMailComposeViewController()
            mailVC.mailComposeDelegate = self.vc as! MFMailComposeViewControllerDelegate?
            mailVC.setToRecipients([self.email])
            mailVC.setSubject("Question regarding \(self.itemName)")
            
            self.vc?.present(mailVC, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Phone Call", style: .default, handler: {
            action in
            let url = NSURL(string: "telprompt://\(self.phone)")!
            UIApplication.shared.openURL(url as URL)
        }))
        alert.addAction(UIAlertAction(title: "Text Message", style: .default, handler: {
            action in
            let messageVC = MFMessageComposeViewController()
            messageVC.messageComposeDelegate = self.vc as! MFMessageComposeViewControllerDelegate?
            messageVC.recipients = [self.phone]
            
            self.vc?.present(messageVC, animated: true, completion: nil)
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.popoverPresentationController?.sourceView = sender as? UIView
        alert.popoverPresentationController?.sourceRect = sender.bounds
        vc?.present(alert, animated: true, completion: nil)
    }
    
    // share the item on social media
    @IBAction func shareItem(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Share this item!", message: "Share our campaign on social media to increase awareness about Cupertino FBLA's online yard sale fundraiser! You can write your own message or paste to get a preset one!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Facebook", style: UIAlertActionStyle.default, handler: { action in
            self.shareFacebook()
        }))
        alert.addAction(UIAlertAction(title: "Twitter", style: UIAlertActionStyle.default, handler: {
            action in
            self.shareTwitter()
        }))
        
        vc?.present(alert, animated: true, completion: nil)
    }
    
    // share the item on Facebook
    func shareFacebook() {
        UIPasteboard.general.string = "My FBLA chapter needs help to fund our trip to nationals! My friend is currently selling \"\(itemName)\" on Agora! Bid on it to help us raise money!"
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook){
            let facebookSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            facebookSheet.add(URL(string: "http://tinofbla.org/"))
            vc?.present(facebookSheet, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            vc?.present(alert, animated: true, completion: nil)
        }
    }
    
    // share the item on Twitter
    func shareTwitter() {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter){
            let twitterSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            twitterSheet.setInitialText("My friend is currently selling \"\(itemName)\" on Agora!")
            twitterSheet.add(#imageLiteral(resourceName: "chs"))
            twitterSheet.add(URL(string: "http://tinofbla.org/"))
            vc?.present(twitterSheet, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to share.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            vc?.present(alert, animated: true, completion: nil)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // customize the buttons in the view with green colored borders
        contactButton.layer.borderWidth = 1
        contactButton.layer.borderColor = UIColor(red:0.00, green:0.69, blue:0.42, alpha:1.00).cgColor
        shareItem.layer.borderWidth = 1
        shareItem.layer.borderColor = UIColor(red:0.00, green:0.69, blue:0.42, alpha:1.00).cgColor
    }
    
}
