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
 
 - Move delegate out of VC? Maybe not needed, really doesn't have that much code
 - Create detail screen for viewing details about each reminder
 - Add update methods to edit reminders (name/type/time range etc)
 - Switch to collection view
 - Add code for scheduling notifications (probably through UserNotifications) and
    allow for users to cancel the upcoming notification/reminder and go onto the
    next one or just cancel entirely (indefinite pause)
 - Sort the reminders on main screen by closest upcoming reminder (retain
    option to sort by name of reminder? - If done this way, likely want to
    add a color tint to the cell indicating how close the next trigger date is)
 - Allow user to sign up with email+password (i.e. update email and password -
    convert an anonymous account to a permanent one)
 */

class RemindersViewController: UIViewController {
    
    // MARK: Properties
    var contentView: RemindersView!
    
    var dataSource: RemindersDataSource = RemindersDataSource()
    
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
        
        dataSource.setupFirebaseListeners { [weak self] in
            guard let self = self else { return }
            // more transition code - might be weird with table view UI updates
            // in other areas though
            UIView.transition(with: self.contentView.remindersTableView, duration: 0.25, options: .transitionCrossDissolve, animations: self.contentView.remindersTableView.reloadData, completion: nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dataSource.removeFirebaseListeners()
    }
    
    // MARK: Setup
    private func setupView() {
        let view = RemindersView()
        contentView = view
    }
    
    private func configureNavBar() {
        navigationItem.title = "Reminders"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(presentSignInVC))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(presentAddReminderSheetVC))
    }
    
    private func setTableViewDelegate() {
        contentView.remindersTableView.delegate = self
        contentView.remindersTableView.dataSource = dataSource
    }
    
    private func setup() {
        setupView()
        configureNavBar()
        setTableViewDelegate()
    }
    
    // MARK: - Utility methods
    // TODO: Maybe move this to datasource?
    private func checkNumberOfDuplicateNames(forName name: String) -> Int {
        var numberOfDuplicates = 0
        let reminderItems = dataSource.allReminderItems()
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
        let signInVC = SignInViewController(delegate: self)
        let navVC = UINavigationController(rootViewController: signInVC)
        navigationController?.present(navVC, animated: true, completion: nil)
    }
}

// MARK: - Add reminder item delegate
extension RemindersViewController: AddReminderItemDelegate {
    func saveReminderItem(_ reminderItem: ReminderItem) {
        let newReminderItemRef = dataSource.getCurrentUserRef().childByAutoId()
        var newReminderItem = reminderItem

        let numberOfDuplicates = checkNumberOfDuplicateNames(forName: reminderItem.nameOfReminder)
        if numberOfDuplicates > 0 {
            newReminderItem.nameOfReminder.append(" (\(numberOfDuplicates))")
        }
        
        dataSource.append(reminderItem: newReminderItem) { [weak self] in
            guard let self = self else { return }
            // use insertRows here so that we get a nice animation :)
            let indexPath = IndexPath(row: self.dataSource.allReminderItems().count - 1, section: 0)
            self.contentView.remindersTableView.insertRows(at: [indexPath], with: .automatic)
        }
        newReminderItemRef.setValue(newReminderItem.toDict())
    }
}

// MARK: - Sign in delegate
extension RemindersViewController: SignInViewDelegate {
    func signInView(_ signInView: SignInView, shouldSignInWith credentials: TempUserCredentials) {
        print("SIGNED IN - VC")
    }
    
    func signInView(_ signInView: SignInView, shouldRegisterWith credentials: TempUserCredentials) {
        print("REGISTERED - VC")
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

