//
//  ReminderPropertiesTableViewCell.swift
//  RemindMe
//
//  Created by Kevin Vu on 10/16/20.
//  Copyright © 2020 Kevin Vu. All rights reserved.
//

import UIKit

protocol NameOfReminderCellDelegate: class {
    func setReminderName(_ name: String)
}

class NameOfReminderCell: UITableViewCell {
    
    // MARK: Constants
    static let identifier = "nameOfReminderTextFieldCellID"
    
    
    // MARK: Properties/UI
    weak var didFinishEditingReminderNameDelegate: NameOfReminderCellDelegate?
    
    lazy var textField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Name of reminder"
        tf.textAlignment = .center
        tf.delegate = self
        return tf
    }()
    
    // MARK: Object lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not implemented")
    }
    
    // MARK: Setup
    private func setup() {
        textLabel?.text = "Name of Reminder:"
        contentView.addSubview(textField)
        textField.setAndActivateConstraints(top: topAnchor, bottom: bottomAnchor, leading: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 16), size: .init(width: (frame.width/2), height: 0))
    }
}

// MARK: Text field delegate
extension NameOfReminderCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "" {
            textField.text = "Untitled"
        }
        textField.selectAll(nil)
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        guard
            let nameOfReminder = textField.text,
            !nameOfReminder.isEmpty
        else { return true }
        
        didFinishEditingReminderNameDelegate?.setReminderName(nameOfReminder)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
