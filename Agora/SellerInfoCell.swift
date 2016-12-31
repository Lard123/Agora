//
//  SellerInfoCell.swift
//  Agora
//
//  Created by Varun Shenoy on 12/14/16.
//  Copyright © 2016 Varun Shenoy. All rights reserved.
//

import UIKit

class SellerInfoCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var profileImage: CustomImageView!
    
    var user: User?
    var vc: ItemVC?
    
    func setUpCell(seller: User, vc: ItemVC) {
        self.vc = vc
        self.user = seller
        profileImage.loadImageUsingUrlString(urlString: seller.pictureURL)
        nameLabel.text = seller.name
    }
    
    @IBAction func toUserDetail(_ sender: Any) {
        vc?.toUserVC(id: (user?.id)!)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
