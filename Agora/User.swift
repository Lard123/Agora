//
//  User.swift
//  Agora
//
//  Created by Varun Shenoy on 12/14/16.
//  Copyright © 2016 Varun Shenoy. All rights reserved.
//

import Foundation

class User: NSObject {
    var name: String = ""
    var phone: String = ""
    var email: String = ""
    var pictureURL: String = ""
    var id: String = ""
    
    init(name: String, phone: String, email: String, pictureURL: String, id: String) {
        self.name = name
        self.phone = phone
        self.email = email
        self.pictureURL = pictureURL
        self.id = id
    }
}
