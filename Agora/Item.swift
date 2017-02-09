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
    // item attributes
    var name: String = ""
    var condition: String = ""
    var descrip: String = ""
    var cost: Double = 0
    var imageURLs = [String]()
    var seller: User!
    var firebaseKey: String = ""
    
    // create a Item object
    init(name: String, condition: String, seller: User, imageURLs: [String], cost: Double, description: String, firebaseKey: String) {
        self.name = name
        self.condition = condition
        self.seller = seller
        self.imageURLs = imageURLs
        self.cost = cost
        self.descrip = description
        self.firebaseKey = firebaseKey
    }
}
