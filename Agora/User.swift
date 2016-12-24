//
//  User.swift
//  Agora
//
//  Created by Varun Shenoy on 12/14/16.
//  Copyright © 2016 Varun Shenoy. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class User: NSObject {
    var name = ""
    var phone = ""
    var email = ""
    var pictureURL = ""
    var id = ""
    
    init(name: String, phone: String, email: String, pictureURL: String, id: String) {
        self.name = name
        self.phone = phone
        self.email = email
        self.pictureURL = pictureURL
        self.id = id
    }
    
    init(sellerID: String) {
        self.id = sellerID
    }
    
    func getUserInfo() {
        let ref = FIRDatabase.database().reference()
        ref.child("users").child(id).observeSingleEvent(of: .value, with: { (snapshot) in
            if let userDict = snapshot.value as? [String : AnyObject] {
                self.name = userDict["name"] as! String
                self.email = userDict["email"] as! String
                self.phone = userDict["phone"] as! String
                self.pictureURL = userDict["image"] as! String
            }
        })
    }
}
