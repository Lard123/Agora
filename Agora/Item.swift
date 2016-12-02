//
//  Item.swift
//  Agora
//
//  Created by Varun Shenoy on 11/23/16.
//  Copyright © 2016 Varun Shenoy. All rights reserved.
//

import Foundation
import UIKit

class Item: NSObject {
    var name: String = ""
    var condition: String = ""
    var seller: String = ""
    var sellerID: String = ""
    var descrip: String = ""
    var cost: Double = 0
    var images = [UIImage]()
    
    init(name: String, condition: String, seller: String, images: [UIImage], cost: Double, sellerID: String, description: String) {
        self.name = name
        self.condition = condition
        self.seller = seller
        self.images = images
        self.cost = cost
        self.sellerID = sellerID
        self.descrip = description
    }
}
