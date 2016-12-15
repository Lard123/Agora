//
//  ItemInfoCell.swift
//  Agora
//
//  Created by Varun Shenoy on 12/14/16.
//  Copyright © 2016 Varun Shenoy. All rights reserved.
//

import UIKit

class ItemInfoCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var costLabel: UILabel!

    @IBOutlet weak var conditionLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUpCell(obj: Item) {
        nameLabel.text = obj.name
        let price = obj.cost as NSNumber
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        costLabel.text = formatter.string(from: price)
        let condition = obj.condition
        if condition == "New with Tags" {
            conditionLabel.textColor = UIColor(red:0.00, green:0.69, blue:0.42, alpha:1.00)
        } else if condition == "Pre-owned" {
            conditionLabel.textColor = UIColor(red:1.00, green:0.49, blue:0.05, alpha:1.00)
        } else {
            conditionLabel.textColor = UIColor(red:0.25, green:0.35, blue:0.59, alpha:1.00)
        }
        conditionLabel.text = condition
        descriptionLabel.text = obj.descrip
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
