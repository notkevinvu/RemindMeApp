//
//  ReminderPropertiesTableViewCell.swift
//  RemindMe
//
//  Created by Kevin Vu on 10/16/20.
//  Copyright © 2020 Kevin Vu. All rights reserved.
//

import UIKit

class NameOfReminderCell: UITableViewCell {
    
    // MARK: Constants
    static let identifier = "nameOfReminderTextFieldCellID"
    var fieldType: AddReminderFieldType = .nameOfReminderTextField
    
    // MARK: Properties/UI
    let textField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Name of reminder..."
        
        return tf
    }()
    
    // MARK: Object lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    // MARK: Setup
    private func setup() {
        contentView.addSubview(textField)
        
        textField.setAndActivateConstraints(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 16))
    }
}


