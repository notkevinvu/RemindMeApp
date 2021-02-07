//
//  TaskViewController.swift
//  RemindMe
//
//  Created by Kevin Vu on 9/25/20.
//  Copyright © 2020 Kevin Vu. All rights reserved.
//

import UIKit
import Firebase

/*
 TODO 7 Dec 2020:
 
 - Create detail screen for viewing details about each reminder
 - Add update methods to edit reminders (name/type/time range etc)
 - Switch to collection view
 - Add code for scheduling notifications (probably through UserNotifications) and
    allow for users to cancel the upcoming notification/reminder and go onto the
    next one or just cancel entirely (indefinite pause)
 - Sort the reminders on main screen by closest upcoming reminder (retain
    option to sort by name of reminder? - If done this way, likely want to
    add a color tint to the cell indicating how close the next trigger date is)
    (Maybe just hold a separate array for locally filtered results in the data
    source and have a function to .filter() the current reminder items
    based on the time remaining and set the array to that filtered array)
 - Move the AddReminderItemDelegate to another class (maybe dataManager as well?
    kinda makes sense but that class is starting to get pretty crowded)
 
 
 - Need to update the nav bar button after registering/signing in to show the
    sign out button instead of the sign in button. Currently, the view does not
    call viewWillAppear after returning from the modal VC
 - After user logs in/registers acc, need to switch the login icon/bar button item
    to sign out instead - store as enum state?
 */

class RemindersViewController: UIViewController {
    
    // MARK: Properties
    var contentView: RemindersView!
    
    lazy var dataManager: RemindersDataManager = RemindersDataManager()
    
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
    override func loadView() {
        super.loadView()
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        dataManager.setupFirebaseListeners { [weak self] in
            guard let self = self else { return }
            self.configureNavBar()
            print("Setting up firebase listeners")
            
            // more transition code - might be weird with table view UI updates
            // in other areas though
            UIView.transition(with: self.contentView.remindersTableView, duration: 0.25, options: .transitionCrossDissolve, animations: self.contentView.remindersTableView.reloadData, completion: nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dataManager.removeFirebaseListeners()
    }
    
    // MARK: Setup
    private func setupView() {
        let view = RemindersView()
        contentView = view
    }
    
    private func setTableViewDelegate() {
        contentView.remindersTableView.delegate = self
        contentView.remindersTableView.dataSource = dataManager
    }
    
    private func setup() {
        setupView()
        setTableViewDelegate()
    }
    
    private func configureNavBar() {
        navigationItem.title = "Reminders"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(presentAddReminderSheetVC))
        
        // TODO: switch case for auth state
        let authState = dataManager.getAuthState()
        
        switch authState {
        case .notSignedIn:
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign In", style: .plain, target: self, action: #selector(presentSignInVC))
        case .signedIn:
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign out", style: .plain, target: self, action: #selector(signOutUser))
        }
        
    }
    
    // MARK: - Utility methods
    // TODO: Maybe move this to datasource?
    private func checkNumberOfDuplicateNames(forName name: String) -> Int {
        var numberOfDuplicates = 0
        let reminderItems = dataManager.allReminderItems()
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
    
    @objc func presentSignInVC() {
        let signInVC = SignInViewController(delegate: dataManager)
        let navVC = UINavigationController(rootViewController: signInVC)
        navVC.modalPresentationStyle = .fullScreen
        navigationController?.present(navVC, animated: true, completion: nil)
    }
    
    // MARK: - Misc button methods
    @objc func signOutUser() {
        dataManager.signOutUser()
        configureNavBar()
        contentView.remindersTableView.reloadData()
    }
}

// MARK: - Add reminder item delegate
extension RemindersViewController: AddReminderItemDelegate {
    func saveReminderItem(_ reminderItem: ReminderItem) {
        let newReminderItemRef = dataManager.getCurrentUserRef().childByAutoId()
        var newReminderItem = reminderItem
        
        let numberOfDuplicates = checkNumberOfDuplicateNames(forName: reminderItem.nameOfReminder)
        if numberOfDuplicates > 0 {
            newReminderItem.nameOfReminder.append(" (\(numberOfDuplicates))")
        }
        
        dataManager.append(reminderItem: newReminderItem) { [weak self] in
            guard let self = self else { return }
            // use insertRows here so that we get a nice animation :)
            let indexPath = IndexPath(row: self.dataManager.allReminderItems().count - 1, section: 0)
            self.contentView.remindersTableView.insertRows(at: [indexPath], with: .automatic)
        }
        newReminderItemRef.setValue(newReminderItem.toDict())
    }
}

// MARK: - Table view methods
extension RemindersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        // TODO: Move to detail screen
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

