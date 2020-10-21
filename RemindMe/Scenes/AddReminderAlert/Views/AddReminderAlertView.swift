//
//  CustomAlertView.swift
//  RemindMe
//
//  Created by Kevin Vu on 10/14/20.
//  Copyright © 2020 Kevin Vu. All rights reserved.
//

import UIKit

class AddReminderAlertView: UIView {
    
    let reminderItemPropertiesTableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .systemBackground
        table.isUserInteractionEnabled = true
        
        table.register(NameOfReminderCell.self, forCellReuseIdentifier: NameOfReminderCell.identifier)
        
        table.register(ReminderTypeTableViewCell.self, forCellReuseIdentifier: ReminderTypeTableViewCell.identifier)
        
        return table
    }()
    
    // MARK: Object lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    // MARK: Setup
    private func setup() {
        backgroundColor = .white
        
        addSubview(reminderItemPropertiesTableView)
        reminderItemPropertiesTableView.setAndActivateConstraints(top: safeAreaLayoutGuide.topAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, centerX: nil, centerY: nil)
    }
}


protocol AddReminderCellType {
    var fieldType: AddReminderFieldType { get }
}

// MARK: Table view cell types enum
enum AddReminderFieldType: Int, CaseIterable {
    case nameOfReminderTextField = 0,
         reminderTypeField, // UIPickerView?
         reminderStartDateField, // UIDatePickerView
         reminderIntervalTimeField, // UIPickerView
         isOneTimeReminderField
    
}
