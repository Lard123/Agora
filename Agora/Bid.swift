//
//  Bid.swift
//  Agora
//
//  Created by Varun Shenoy on 12/21/16.
//  Copyright © 2016 Varun Shenoy. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

class Bid: NSObject {
    
    // bid attributes
    var cost = 0.0
    var timeStamp = ""
    var userID = ""
    var name = ""
    var pictureURL = ""
    var email = ""
    var phone = ""
    var numericTimeStamp = 0.0
    
    // initialize the bid with raw information
    init(cost: Double, userID: String, timeStamp: Double) {
        self.numericTimeStamp = timeStamp
        self.cost = cost
        self.userID = userID
        let date = Date(timeIntervalSince1970: timeStamp)
        let df = DateFormatter()
        df.dateFormat = "MMM d, h:mm a"
        self.timeStamp = df.string(from: date)

    }
    
    // get the information about the bidder from Firebase
    func getUserInfo(completionHandler:@escaping (Bool) -> ()) {
        let ref = FIRDatabase.database().reference()
        ref.child("users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let userDict = snapshot.value as? [String : AnyObject] {
                self.name = userDict["name"] as! String
                self.pictureURL = userDict["image"] as! String
                self.email = userDict["email"] as! String
                self.phone = userDict["phone"] as! String
                print("name: " + self.name)
                print("pictureURL: " + self.pictureURL)
                completionHandler(true)
            }
        })
    }
    
}
