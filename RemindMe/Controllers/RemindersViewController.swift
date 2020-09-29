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
    
    // MARK: Properties
    
    let usersRef = Database.database().reference(withPath: "users")
    
    var reminderItems = [ReminderItem]()
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    // MARK: Setup
    private func setup() {
        let contentView = RemindersView()
        contentView.setDelegate(to: self)
        contentView.remindersTableView.delegate = self
        contentView.remindersTableView.dataSource = self
        
        view = contentView
    }

}

extension RemindersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminderItems.count
//        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RemindersTableViewCell.cellID, for: indexPath) as! RemindersTableViewCell
        
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

