//
//  OwnerActionsCell.swift
//  Agora
//
//  Created by Varun Shenoy on 12/21/16.
//  Copyright © 2016 Varun Shenoy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class OwnerActionsCell: UITableViewCell {

    @IBOutlet weak var seeOffersButton: UIButton!
    
    @IBOutlet weak var deleteItemButton: UIButton!
    
    var itemID = ""
    var vc: ItemVC?
    var ref: FIRDatabaseReference!
    
    func setUpCell(itemID: String,  vc: ItemVC) {
        ref = FIRDatabase.database().reference()
        self.itemID = itemID
        self.vc = vc
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        ref = FIRDatabase.database().reference()
        deleteItemButton.layer.borderWidth = 1
        deleteItemButton.layer.borderColor = UIColor(red:1.00, green:0.17, blue:0.27, alpha:1.00).cgColor
    }

    @IBAction func deleteCurrentItem(_ sender: AnyObject) {
        // create the alert
        let alert = UIAlertController(title: "Delete Item", message: "Would you like to delete this item from the marketplace?", preferredStyle: UIAlertControllerStyle.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive) { (result: UIAlertAction) -> Void in
            let itemRef = self.ref.child("items").child(self.itemID)
            itemRef.removeValue()
            let userItemRef = self.ref.child("users").child((FIRAuth.auth()?.currentUser?.uid)!).child("items").child(self.itemID)
            userItemRef.removeValue()
            self.vc?.performSegue(withIdentifier: "toMarket", sender: self.vc)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        // show the alert
        vc?.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func seeOffersForItem(_ sender: AnyObject) {
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
