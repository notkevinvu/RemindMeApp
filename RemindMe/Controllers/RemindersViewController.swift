//
//  TaskViewController.swift
//  RemindMe
//
//  Created by Kevin Vu on 9/25/20.
//  Copyright © 2020 Kevin Vu. All rights reserved.
//

import UIKit
import Firebase

class RemindersViewController: UIViewController {
    
    // MARK: Constants
    let usersConstant = "users"
    let reminderItemsConstant = "reminder-items"
    
    // MARK: Properties
    
    var contentView: RemindersView!
    
    lazy var usersRef = Database.database().reference(withPath: usersConstant)
    lazy var reminderItemsRef = usersRef.child(reminderItemsConstant)
    
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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableViewDelegate()
        configureNavBar()
    }
    
    override func loadView() {
        super.loadView()
        view = contentView
    }
    
    // MARK: Setup
    private func setup() {
        let view = RemindersView()
        contentView = view
    }
    
    private func setTableViewDelegate() {
        contentView.setDelegate(to: self)
        contentView.remindersTableView.delegate = self
        contentView.remindersTableView.dataSource = self
    }
    
    private func configureNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddReminderBarButton))
    }
    
    // MARK: Bar button methods
    
    @objc func didTapAddReminderBarButton() {
        let ac = UIAlertController(title: "Reminder",
                                   message: "Add a reminder",
                                   preferredStyle: .alert)
        
        // 0 - name of reminder
        // 1 - user (should eventually be email of user
        // 2 - reminder type (should be a UIPickerView eventually)
        // 3 - date added (current date)
        // 4 - current interval start date (just use current date)
        ac.addTextField()
        ac.textFields?.first?.placeholder = "Name of reminder"
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] (action) in
            
            guard
                let self = self,
                let textField = ac.textFields?.first,
                let nameText = textField.text else { return }
            
            let reminder = ReminderItem(nameOfReminder: nameText, addedByUser: "kevinvu59@gmail.com", reminderType: .routineTask, currentIntervalStartDate: Date())
            
            let reminderItemRef = self.reminderItemsRef.child(nameText.lowercased())
            
            reminderItemRef.setValue(reminder.toDict())
            
            self.reminderItems.append(reminder)
            self.contentView.remindersTableView.reloadData()
        }
        
        ac.addAction(cancelAction)
        ac.addAction(saveAction)
        
        present(ac, animated: true, completion: nil)
    }
}

extension RemindersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminderItems.count
//        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RemindersTableViewCell.cellID, for: indexPath) as! RemindersTableViewCell
        
        let model = RemindersTableViewCell.RemindersCellModel(nameOfReminder: reminderItems[indexPath.row].nameOfReminder, timeRemaining: 5, reminderType: reminderItems[indexPath.row].reminderType)
        
        cell.configureCell(withModel: model)
        /*
         TODO: Add a date variable to ReminderItem and delegate checking
         the time remaining to a separate model/worker
         
         This needs to check the stored dateinterval and/or the remaining time
         so that the remaining time can be updated and presented as a string
         */
//        let cellModel = RemindersTableViewCell.RemindersCellModel(nameOfReminder: reminderItems[indexPath.row].nameOfReminder, timeRemaining: 10)
        
//        cell.configureCell(withModel: cellModel, forReminderType: "")
        
        return cell
    }
    
    
    
    
}

extension RemindersViewController: RemindersViewDelegate {
    
    func didTapAddReminderButton() {
        print("Tapped add")
    }
    
    func didTapRemoveReminderButton() {
        print("Tapped remove")
    }
    
    
}

