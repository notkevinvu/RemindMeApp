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
 TODO: Order of operations:
 
 1) When user launches app, this VC is created
 
 2) We then need to handle authentication/logging in
 
 3) After authentication/logging in is finished, we then need to get the
 reminder items from firebase through the observer (i.e. add observer)
 
 4) We then pass these items into the array that holds them
 */

class RemindersViewController: UIViewController, AddReminderItemDelegate {
    
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
    
    private func configureNavBar() {
        navigationItem.title = "Reminders"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(presentAddReminderSheetVC))
    }
    
    // MARK: - TODO: CHANGE TABLE VIEW DELEGATE
    private func setTableViewDelegate() {
        contentView.remindersTableView.delegate = self
        
        contentView.remindersTableView.dataSource = dataSource
    }
    
    private func setup() {
        setupView()
        configureNavBar()
        setTableViewDelegate()
    }
    
    // MARK: Delegate methods
    func saveReminderItem(_ reminderItem: ReminderItem) {
        let newReminderItemRef = dataSource.getCurrentUserRef().childByAutoId()
        var newReminderItem = reminderItem

        let numberOfDuplicates = checkNumberOfDuplicateNames(forName: reminderItem.nameOfReminder)
        if numberOfDuplicates > 0 {
            newReminderItem.nameOfReminder.append(" (\(numberOfDuplicates))")
        }
        
        dataSource.append(reminderItem: newReminderItem) { [weak self] in
            guard let self = self else { return }
            // use reloadRows here so that we get a nice animation :)
            let indexPath = IndexPath(row: self.dataSource.allReminderItems().count - 1, section: 0)
            self.contentView.remindersTableView.insertRows(at: [indexPath], with: .automatic)
        }
        newReminderItemRef.setValue(newReminderItem.toDict())
    }
    
    // MARK: - Utility methods
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

