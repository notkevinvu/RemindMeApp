//
//  CustomAlertViewController.swift
//  RemindMe
//
//  Created by Kevin Vu on 10/14/20.
//  Copyright © 2020 Kevin Vu. All rights reserved.
//

import UIKit

protocol AddReminderItemDelegate: class {
    // TODO: add function to pass data back to RemindersViewController to
    // add the reminder item
}

class AddReminderAlertController: UIViewController {
    
    // MARK: Properties
    var contentView: AddReminderAlertView!
    
    // TODO: set the delegate to be the reminders VC so we can access the user refs
    weak var addReminderItemDelegate: AddReminderItemDelegate?
    
    // MARK: Object lifecycle
    init() {
        super.init(nibName: nil, bundle: nil)
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
        configureNavBar()
    }
    
    // MARK: Setup
    private func setup() {
        let view = AddReminderAlertView()
        contentView = view
        view.reminderItemPropertiesTableView.delegate = self
        view.reminderItemPropertiesTableView.dataSource = self
    }
    
    private func configureNavBar() {
        title = "Add Reminder"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleTapCancelBarButton))
        navigationItem.leftBarButtonItem?.tintColor = .systemRed
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(handleTapDoneBarButton))
    }
    
    // MARK: Button methods
    @objc func handleTapCancelBarButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleTapDoneBarButton() {
        print("Tapped done button")
    }
    
}

// MARK: Table View methods
extension AddReminderAlertController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return orderedCells.count
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: NameOfReminderCell.identifier, for: indexPath) as! NameOfReminderCell
            cell.textField.delegate = self
            
            return cell
        }

        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ReminderTypeTableViewCell.identifier, for: indexPath) as! ReminderTypeTableViewCell
            
            return cell
        }
        
        let cell = UITableViewCell()
        cell.textLabel?.text = "Default cell"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // default cell height - adding certain views overrides default cell height
        // for some reason
        return 40
    }
    
}

// MARK: Text field delegate
extension AddReminderAlertController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.addTarget(self, action: #selector(valueChanged), for: .editingChanged)
    }
    
    @objc func valueChanged(_ sender: UITextField) {
        print("Changed something")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

