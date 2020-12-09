//
//  CustomAlertViewController.swift
//  RemindMe
//
//  Created by Kevin Vu on 10/14/20.
//  Copyright © 2020 Kevin Vu. All rights reserved.
//

import UIKit
import Firebase

protocol AddReminderItemDelegate: AnyObject {
    func saveReminderItem(_ reminderItem: ReminderItem)
}

class AddReminderAlertController: UIViewController {
    
    // MARK: - Properties
    var contentView: AddReminderAlertView!
    
    // store these properties here to send to delegate when needed
    var nameOfReminder: String? = nil
    var reminderType: ReminderType? = nil
    var intervalStartDate: Date? = nil
    var intervalTimeType: ReminderIntervalTimeType? = nil
    var intervalTimeValue: Int? = nil
    
    weak var addReminderItemDelegate: AddReminderItemDelegate?
    
    // MARK: - Object lifecycle
    init() {
        super.init(nibName: nil, bundle: nil)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    // MARK: - View lifecycle
    override func loadView() {
        super.loadView()
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
    }
    
    // MARK: - Setup
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
    
    // MARK: - Button methods
    @objc func handleTapCancelBarButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleTapDoneBarButton() {
        guard
            let nameOfReminder = nameOfReminder,
            let reminderType = reminderType,
            let intervalStartDate = intervalStartDate,
            let intervalTimeType = intervalTimeType,
            let intervalTimeValue = intervalTimeValue,
            let currentUser = Auth.auth().currentUser
        else { return }
        
        var calendarComponent: Calendar.Component
        
        switch intervalTimeType {
        case .days:
            calendarComponent = .day
        case .weeks:
            calendarComponent = .weekOfYear
        case .months:
            calendarComponent = .month
        case .years:
            calendarComponent = .year
        default:
            return
        }
        
        var components = DateComponents()
        components.setValue(intervalTimeValue, for: calendarComponent)
        guard let upcomingIntervalTriggerDate = Calendar.current.date(byAdding: components, to: intervalStartDate) else { return }
        
        let currentUserIdentifier = currentUser.email ?? currentUser.uid
        let reminderItem = ReminderItem(nameOfReminder: nameOfReminder,
                                        addedByUser: currentUserIdentifier,
                                        reminderType: reminderType,
                                        dateAdded: Date(),
                                        currentIntervalStartDate: intervalStartDate,
                                        reminderIntervalTimeType: intervalTimeType,
                                        reminderIntervalTimeValue: intervalTimeValue,
                                        upcomingReminderTriggerDate: upcomingIntervalTriggerDate)
        
        addReminderItemDelegate?.saveReminderItem(reminderItem)
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Table View methods
extension AddReminderAlertController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        
        // manual ordering of cells
        switch row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: NameOfReminderCell.identifier, for: indexPath) as! NameOfReminderCell
            cell.didFinishEditingReminderNameDelegate = self
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: ReminderTypeTableViewCell.identifier, for: indexPath) as! ReminderTypeTableViewCell
            cell.didFinishPickingReminderTypeDelegate = self
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: IntervalStartDateTableViewCell.identifier, for: indexPath) as! IntervalStartDateTableViewCell
            cell.didFinishPickingIntervalStartDateDelegate = self
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: IntervalTimeTableViewCell.identifier, for: indexPath) as! IntervalTimeTableViewCell
            cell.didFinishPickingIntervalTimeDelegate = self
            return cell
        default:
            let cell = UITableViewCell()
            cell.textLabel?.text = "Default cell"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // default cell height - adding certain views overrides default cell height
        // for some reason
        return 40
    }
    
}

// MARK: - Cell delegates
extension AddReminderAlertController: NameOfReminderCellDelegate {
    func setReminderName(_ name: String) {
        self.nameOfReminder = name
    }
}

extension AddReminderAlertController: ReminderTypeCellDelegate {
    func setReminderType(_ reminderType: ReminderType) {
        self.reminderType = reminderType
    }
}

extension AddReminderAlertController: IntervalStartDateCellDelegate {
    func setIntervalStartDate(_ date: Date) {
        self.intervalStartDate = date
    }
}

extension AddReminderAlertController: IntervalTimeCellDelegate {
    func setIntervalTime(type: ReminderIntervalTimeType, value: Int) {
        intervalTimeType = type
        intervalTimeValue = value
    }
    
    func didTapCancelButton() {
        intervalTimeType = nil
        intervalTimeValue = nil
    }
}
