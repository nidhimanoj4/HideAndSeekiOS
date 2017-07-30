//
//  User.swift
//  Hide-And-Seek
//
//  Created by Neena Dugar on 29/07/2017.
//  Copyright © 2017 Nidhi Manoj. All rights reserved.
//

import Foundation
import Firebase

class User{
    var ref: DatabaseReference!
    
    ref = Database.database().reference()
    
    init(uid: Int) {
        self.ref.child("users").child(user.uid).setValue(["status": "playing"])
    }
    
    getLocation() {
    
    }
}
