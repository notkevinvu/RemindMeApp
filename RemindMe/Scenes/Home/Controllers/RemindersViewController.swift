//
//  TaskViewController.swift
//  RemindMe
//
//  Created by Kevin Vu on 9/25/20.
//  Copyright © 2020 Kevin Vu. All rights reserved.
//

import UIKit
import Firebase

class RemindersViewController: UIViewController, AddReminderItemDelegate {
    
    // MARK: Constants
    // used as a reference path to the firebase db
    let usersConstant = "users"
    
    // MARK: Properties
    
    var contentView: RemindersView!
    
    // TODO: Maybe add these via dependency injection?
    var firebaseAuthService = FirebaseAuthenticationService()
    var firebaseObserverService = FirebaseObserverService()
    
    var user: User = User(uid: "fakeID", email: "fakeEmail@example.com")
    lazy var usersRef = Database.database().reference(withPath: usersConstant)
    lazy var currentUserRef = usersRef.child(user.uid)
    
    var reminderItems = [ReminderItem]()
    
    // MARK: Object lifecycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    // MARK: View lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFirebaseListeners()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        firebaseAuthService.removeAuthListener()
    }
    
    override func loadView() {
        super.loadView()
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Setup
    private func setupView() {
        let view = RemindersView()
        contentView = view
    }
    
    private func setTableViewDelegate() {
        contentView.remindersTableView.delegate = self
        contentView.remindersTableView.dataSource = self
    }
    
    private func configureNavBar() {
        navigationItem.title = "Reminders"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(presentAddReminderSheetVC))
    }
    
    private func setup() {
        setupView()
        setTableViewDelegate()
        configureNavBar()
    }
    
    private func setupFirebaseListeners() {
        // this adds auth listener as well
        firebaseAuthService.authenticateUser { [weak self] (user) in
            guard let self = self else { return }
            self.user = user
            
            self.firebaseObserverService.addObserver(to: self.currentUserRef) { (newReminderItems) in
                self.reminderItems = newReminderItems
                self.contentView.remindersTableView.reloadData()
            }
        }
    }
    
    // MARK: Delegate methods
    // TODO: extract this into its own class/struct?
    // then we can call something like
    // firebaseObjectService.saveReminderItem(_:)
    func saveReminderItem(_ reminderItem: ReminderItem) {
        let autoIDReminderItemRef = currentUserRef.childByAutoId()
        var newReminderItem = reminderItem
        
        let numberOfDuplicates = checkNumberOfDuplicateNames(forName: reminderItem.nameOfReminder)
        if numberOfDuplicates > 0 {
            newReminderItem.nameOfReminder.append(" (\(numberOfDuplicates))")
        }
        
        self.reminderItems.append(newReminderItem)
        autoIDReminderItemRef.setValue(newReminderItem.toDict())
    }
    
    // MARK: - Utility methods
    private func checkNumberOfDuplicateNames(forName name: String) -> Int {
        var numberOfDuplicates = 0
        for item in reminderItems {
            if name == item.nameOfReminder {
                numberOfDuplicates += 1
            }
        }
        return numberOfDuplicates
    }
    
    // MARK: Navigation
    @objc func presentAddReminderSheetVC() {
        let addReminderAlertVC = AddReminderAlertController()
        addReminderAlertVC.addReminderItemDelegate = self
        let navVC = UINavigationController(rootViewController: addReminderAlertVC)
        navigationController?.present(navVC, animated: true, completion: nil)
    }
    
    // MARK: Reminder items ref observer
    
    private func addRemindersRefObserver() {
        currentUserRef.observe(.value) { (snapshot) in
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
            
            self.reminderItems = newReminderItems
            self.contentView.remindersTableView.reloadData()
        }
    }
    
}

// MARK: - Table view methods
extension RemindersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminderItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RemindersTableViewCell.cellID, for: indexPath) as! RemindersTableViewCell
        
        let reminderItem = reminderItems[indexPath.row]
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.year, .month, .weekOfMonth, .day]
        formatter.includesTimeRemainingPhrase = true
        let timeStringUntilTriggerDate = formatter.string(from: Date(), to: reminderItem.upcomingReminderTriggerDate) ?? "Error formatting remaining time."
        
        let model = RemindersTableViewCell.RemindersCellModel(
            nameOfReminder  : reminderItem.nameOfReminder,
            timeRemaining   : reminderItem.reminderIntervalTimeValue,
            reminderType    : reminderItem.reminderType,
            timeStringUntilTriggerDate: timeStringUntilTriggerDate
        )
        
        cell.configureCell(withModel: model)

        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        // TODO: Move to detail screen
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let row = indexPath.row
            let reminderItem = reminderItems[row]
            reminderItem.ref?.removeValue()
            tableView.reloadRows(at: [indexPath], with: .left)
            reminderItems.remove(at: row)
        }
    }
}

