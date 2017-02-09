//
//  SellerInfoCell.swift
//  Agora
//
//  Created by Varun Shenoy on 12/14/16.
//  Copyright © 2016 Varun Shenoy. All rights reserved.
//

import UIKit

class SellerInfoCell: UITableViewCell {

    // outlets to user interface items in the view controller
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var profileImage: CustomImageView!
    
    var user: User?
    var vc: ItemVC?
    
    func setUpCell(seller: User, vc: ItemVC) {
        
        // show seller information
        self.vc = vc
        self.user = seller
        profileImage.loadImageUsingUrlString(urlString: seller.pictureURL)
        nameLabel.text = seller.name
    }
    
    // if the seller is tapped on, show their profile
    @IBAction func toUserDetail(_ sender: Any) {
        vc?.toUserVC(id: (user?.id)!)
    }

}
