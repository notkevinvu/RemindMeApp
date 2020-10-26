//
//  ReminderTypeTableViewCell.swift
//  RemindMe
//
//  Created by Kevin Vu on 10/17/20.
//  Copyright © 2020 Kevin Vu. All rights reserved.
//

import UIKit

class ReminderTypeTableViewCell: UITableViewCell {
    
    // MARK: Constants
    static let identifier = "reminderTypeCellID"
    
    // MARK: Properties
    var textField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Reminder type"
        tf.textAlignment = .center
        tf.font = UIFont.boldSystemFont(ofSize: 16)
        
        // hides blinking cursor
        tf.tintColor = .clear
        
        return tf
    }()
    
    lazy var reminderTypePickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        
        return picker
    }()
    
    lazy var toolBar: UIToolbar = {
        let tb = UIToolbar()
        tb.barStyle = .default
        tb.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        tb.setItems([spaceButton, doneButton], animated: false)
        
        return tb
    }()
    
    private var reminderTypes: [ReminderType] = [.routineTask, .refillItem, .generic]
    
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
        textLabel?.text = "Reminder type:"
        selectionStyle = .none
        contentView.addSubview(textField)
        textField.inputView = reminderTypePickerView
        textField.inputAccessoryView = toolBar
        
        textField.setAndActivateConstraints(top: safeAreaLayoutGuide.topAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, leading: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 16), size: .init(width: (frame.width / 2), height: 0))
        
        reminderTypePickerView.delegate = self
        reminderTypePickerView.dataSource = self
    }
    
    // MARK: Utility methods
    
    @objc func donePicker() {
        textField.resignFirstResponder()
    }
}

// MARK: Picker view delegate
extension ReminderTypeTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return reminderTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let reminderType = reminderTypes[row]
        return reminderType.rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let reminderType = reminderTypes[row]
        textField.text = reminderType.rawValue
    }
}
