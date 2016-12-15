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
    
    func setUpCell(seller: User) {
        profileImage.loadImageUsingUrlString(urlString: seller.pictureURL)
        nameLabel.text = seller.name
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
