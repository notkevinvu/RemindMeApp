//
//  ReminderItem.swift
//  RemindMe
//
//  Created by Kevin Vu on 9/28/20.
//  Copyright © 2020 Kevin Vu. All rights reserved.
//

import Foundation
import Firebase

enum ReminderType: String {
    case routineTask, refillItem, generic
}

struct ReminderItem {
    
    // MARK: Properties
    let ref: DatabaseReference?
    let key: String
    
    let nameOfReminder: String
    let addedByUser: String
    let reminderType: ReminderType
    
    // the interval used to determine the next time the user should do the task/refill an item (i.e. every 6 months, monthly, every week, etc)
//    let reminderInterval: DateInterval
    // the time remaining until the task/item should be fulfilled (i.e. two weeks left, 5 days left, 3 months left, etc)
//    let remainingTime: DateComponents
    
    // MARK: Initializers
    init(nameOfReminder: String, addedByUser user: String, key: String = "", reminderType: ReminderType) {
        self.ref = nil
        self.key = key
        self.nameOfReminder = nameOfReminder
        self.addedByUser = user
        self.reminderType = reminderType
//        self.reminderInterval = reminderInterval
//        self.remainingTime = remainingTime
    }
    
    // convenience initializer for reminders fetched from firebase as snapshots
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let nameOfReminder = value["nameOfReminder"] as? String,
            let addedByUser = value["addedByUser"] as? String,
            let reminderType = value["reminderType"] as? String
//            let reminderInterval = value["reminderInterval"] as? String,
//            let remainingTime = value["remainingTime"] as? String
        else {
            return nil
        }
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.nameOfReminder = nameOfReminder
        self.addedByUser = addedByUser
        
//        let formatter = DateIntervalFormatter()
        
        switch reminderType {
        case ReminderType.routineTask.rawValue:
            self.reminderType = .routineTask
        case ReminderType.refillItem.rawValue:
            self.reminderType = .refillItem
        default:
            self.reminderType = .generic
        }
    }
    
    // MARK: Utility methods
    
    // converts our ReminderItem struct into a dictionary for convenience
    // when using the setValue(_:) method on a reference to save data to firebase
    // (setValue(_:) expects a dictionary)
    func toDict() -> Any {
        return [
            "nameOfReminder": nameOfReminder,
            "addedByUser": addedByUser,
            "reminderType": reminderType
        ]
    }
    
}
