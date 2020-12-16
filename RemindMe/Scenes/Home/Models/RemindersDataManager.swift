//
//  RemindersTableViewDataSource.swift
//  RemindMe
//
//  Created by Kevin Vu on 12/6/20.
//  Copyright © 2020 Kevin Vu. All rights reserved.
//

import UIKit
import Firebase

// this class is currently more like a data manager and takes care of some
// business logic as well
class RemindersDataManager: NSObject, UITableViewDataSource {
    
    // MARK: - Properties
    var user: User = User(uid: "fakeID", email: "fakeEmail@example.com")
    private let usersRef = Database.database().reference(withPath: "users")
    private lazy var currentUserRef = usersRef.child(user.uid)
    
    private var reminderItems = [ReminderItem]()
    
    // TODO: Maybe inject these through initializer?
    private var firebaseAuthService = FirebaseAuthenticationService()
    private var firebaseObserverService = FirebaseObserverService()
    
    private let dateComponentsFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.year, .month, .weekOfMonth, .day]
        formatter.includesTimeRemainingPhrase = true
        return formatter
    }()
    
    // MARK: - Object lifecycle
    override init() {
        super.init()
        setupFirebaseListeners { }
    }
    
    // MARK: - Utility methods
    public func getCurrentUserRef() -> DatabaseReference {
        return currentUserRef
    }
    
    public func currentUser() -> User {
        return user
    }
    
    public func allReminderItems() -> [ReminderItem] {
        return reminderItems
    }
    
    public func reminderItem(at index: Int) -> ReminderItem {
        return reminderItems[index]
    }
    
    public func append(reminderItem: ReminderItem, completion: @escaping () -> Void) {
        reminderItems.append(reminderItem)
        completion()
    }
    
    public func removeReminderItem(at index: Int, completion: @escaping () -> Void) {
        reminderItems.remove(at: index)
        completion()
    }
    
    // MARK: - Firebase observer methods
    public func setupFirebaseListeners(completion: @escaping () -> Void) {
        firebaseAuthService.authenticateUser { [weak self] (user) in
            guard let self = self else { return }
            self.user = user
            
            self.firebaseObserverService.addObserver(to: self.currentUserRef) { (newReminderItems) in
                self.reminderItems = newReminderItems
                completion()
            }
        }
    }
    
    public func removeFirebaseListeners() {
        firebaseAuthService.removeAuthListener()
        firebaseObserverService.removeAllObservers(from: currentUserRef) { }
    }
    
    // MARK: - Table view methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminderItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RemindersTableViewCell.cellID, for: indexPath) as! RemindersTableViewCell
        
        let reminderItem = reminderItems[indexPath.row]
        
        let timeUntilTriggerDateString = dateComponentsFormatter.string(from: Date(), to: reminderItem.upcomingReminderTriggerDate) ?? "Error formatting remaining time."
        
        let model = RemindersTableViewCell.RemindersCellModel(
            nameOfReminder  : reminderItem.nameOfReminder,
            timeRemaining   : reminderItem.reminderIntervalTimeValue,
            reminderType    : reminderItem.reminderType,
            timeUntilTriggerDateString: timeUntilTriggerDateString
        )
        
        cell.configureCell(withModel: model)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let row = indexPath.row
            let reminderItem = reminderItems[row]
            reminderItem.ref?.removeValue()
            tableView.reloadRows(at: [indexPath], with: .left)
            removeReminderItem(at: row) { }
        }
    }
}
