//
//  CustomAlertView.swift
//  RemindMe
//
//  Created by Kevin Vu on 10/14/20.
//  Copyright © 2020 Kevin Vu. All rights reserved.
//

import UIKit

// We use this implementation to override the intrinsic content size and
// only have the table view be as tall as the sum of the cells' heights it contains
class ResizingTableView: UITableView {
    override var intrinsicContentSize: CGSize {
        return self.contentSize
    }
    
    override var contentSize: CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }
}

class AddReminderAlertView: UIView {
    
    let reminderItemPropertiesTableView: ResizingTableView = {
        let table = ResizingTableView()
        table.backgroundColor = .systemBackground
        table.isUserInteractionEnabled = true
        
        table.register(NameOfReminderCell.self, forCellReuseIdentifier: NameOfReminderCell.identifier)
        table.register(ReminderTypeTableViewCell.self, forCellReuseIdentifier: ReminderTypeTableViewCell.identifier)
        table.register(IntervalStartDateTableViewCell.self, forCellReuseIdentifier: IntervalStartDateTableViewCell.identifier)
        
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
        reminderItemPropertiesTableView.setAndActivateConstraints(top: safeAreaLayoutGuide.topAnchor, bottom: nil, leading: leadingAnchor, trailing: trailingAnchor, centerX: nil, centerY: nil)
    }
}
