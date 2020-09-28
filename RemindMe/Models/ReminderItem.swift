//
//  ReminderItem.swift
//  RemindMe
//
//  Created by Kevin Vu on 9/28/20.
//  Copyright © 2020 Kevin Vu. All rights reserved.
//

import Foundation
import Firebase

struct ReminderItem {
    
    let ref: DatabaseReference?
    let key: String
    
    let nameOfReminder: String
    let addedByUser: String
    
    init(nameOfReminder: String, addedByUser user: String, key: String = "") {
        self.ref = nil
        self.key = key
        self.nameOfReminder = nameOfReminder
        self.addedByUser = user
    }
    
    // convenience initializer for reminders fetched from firebase as snapshots
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let nameOfReminder = value["nameOfReminder"] as? String,
            let addedByUser = value["addedByUser"] as? String
        else {
            return nil
        }
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.nameOfReminder = nameOfReminder
        self.addedByUser = addedByUser
    }
    
    // converts our ReminderItem struct into a dictionary for convenience
    // when using the setValue(_:) method on a reference to save data to firebase
    // (setValue(_:) expects a dictionary)
    func toDict() -> Any {
        return [
            "nameOfReminder": nameOfReminder,
            "addedByUser": addedByUser,
        ]
    }
    
}
