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
    var owner: String = ""
    var cost: Double = 0
    var image = UIImage()
    
    init(name: String, condition: String, owner: String, image: UIImage, cost: Double) {
        self.name = name
        self.condition = condition
        self.owner = owner
        self.image = image
        self.cost = cost
    }
    
    func getImageHeight() -> CGFloat {
        let heightInPoints = image.size.height
        let heightInPixels = heightInPoints * image.scale
        return heightInPixels
    }
}
