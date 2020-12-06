//
//  FirebaseObserverService.swift
//  RemindMe
//
//  Created by Kevin Vu on 11/24/20.
//  Copyright © 2020 Kevin Vu. All rights reserved.
//

import Foundation
import Firebase

struct FirebaseObserverService {
    public func addObserver(to reference: DatabaseReference, completion: @escaping ([ReminderItem]) -> Void) {
        reference.observe(.value) { (snapshot) in
            var newReminderItems: [ReminderItem] = []
            
            for child in snapshot.children {
                guard
                    let snapshot = child as? DataSnapshot,
                    let reminderItem = ReminderItem(snapshot: snapshot)
                else {
                    print("Error getting reminder items")
                    return
                }
                newReminderItems.append(reminderItem)
            }
            
            completion(newReminderItems)
        }
    }
    
    public func removeAllObservers(from reference: DatabaseReference, completion: @escaping () -> Void) {
        reference.removeAllObservers()
        completion()
    }
}
