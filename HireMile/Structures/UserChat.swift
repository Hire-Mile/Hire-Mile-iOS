//
//  UserChat.swift
//  HireMile
//
//  Created by JJ Zapata on 12/27/20.
//  Copyright © 2020 Jorge Zapata. All rights reserved.
//

import UIKit

class UserChat: NSObject {
    
    var id: String?
    var name: String?
    var email: String?
    var profileImageUrl: String?
    init(dictionary: [String: AnyObject]) {
        self.id = dictionary["id"] as? String
        self.name = dictionary["name"] as? String
        self.email = dictionary["email"] as? String
        self.profileImageUrl = dictionary["profile-image"] as? String
    }

}
