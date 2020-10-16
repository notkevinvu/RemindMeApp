//
//  User.swift
//  RemindMe
//
//  Created by Kevin Vu on 9/27/20.
//  Copyright © 2020 Kevin Vu. All rights reserved.
//

import Foundation
import Firebase

struct User {
    
    let uid: String
    // email is optional since we will have anonymous sign-in by default
    let email: String?
    
    init(authData: Firebase.User) {
        uid = authData.uid
        email = authData.email
    }
    
    init(uid: String, email: String?) {
        self.uid = uid
        self.email = email
    }
    
}
