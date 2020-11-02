//
//  RemindersTableViewCell.swift
//  RemindMe
//
//  Created by Kevin Vu on 9/28/20.
//  Copyright © 2020 Kevin Vu. All rights reserved.
//

import UIKit

class RemindersTableViewCell: UITableViewCell {
    
    // MARK: Properties
    static let cellID = "RemindersTableViewCell"
    
    private var nameOfReminder: String? {
        didSet {
            textLabel?.text = nameOfReminder
        }
    }
    private var timeRemaining: String?
    private var reminderType: String?
    
    // MARK: Cell model
    struct RemindersCellModel {
        var nameOfReminder: String
        var timeRemaining: String
        var reminderType: ReminderType
        
        init(nameOfReminder: String, timeRemaining: Int, reminderType: ReminderType) {
            self.nameOfReminder = nameOfReminder
            self.timeRemaining = String(timeRemaining)
            self.reminderType = reminderType
        }
    }
    
    // MARK: Object lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        configureCellStyle()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureCellStyle()
    }
    
    // MARK: Helper methods
    private func configureCellStyle() {
        textLabel?.font = UIFont.systemFont(ofSize: 16)
        detailTextLabel?.font = UIFont.systemFont(ofSize: 10)
    }
    
    func configureCell(withModel model: RemindersTableViewCell.RemindersCellModel) {
        self.nameOfReminder = model.nameOfReminder
        detailTextLabel?.text = model.reminderType.rawValue
    }

}
