//
//  ActionCell.swift
//  Agora
//
//  Created by Varun Shenoy on 12/13/16.
//  Copyright © 2016 Varun Shenoy. All rights reserved.
//

import UIKit
import MessageUI

class ActionCell: UITableViewCell {
    
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
    
    @IBAction func addBid(_ sender: AnyObject) {
    }
    
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
    
    @IBAction func shareItem(_ sender: AnyObject) {
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        contactButton.layer.borderWidth = 1
        contactButton.layer.borderColor = UIColor(red:0.00, green:0.69, blue:0.42, alpha:1.00).cgColor
        shareItem.layer.borderWidth = 1
        shareItem.layer.borderColor = UIColor(red:0.00, green:0.69, blue:0.42, alpha:1.00).cgColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
