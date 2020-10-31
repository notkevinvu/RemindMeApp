//
//  ReminderTypeTableViewCell.swift
//  RemindMe
//
//  Created by Kevin Vu on 10/17/20.
//  Copyright © 2020 Kevin Vu. All rights reserved.
//

import UIKit

protocol ReminderTypeCellDelegate: class {
    func setReminderType(_ reminderType: ReminderType)
}

class ReminderTypeTableViewCell: UITableViewCell {
    
    // MARK: Constants
    static let identifier = "reminderTypeCellID"
    
    
    // MARK: Properties
    weak var didFinishPickingReminderTypeDelegate: ReminderTypeCellDelegate?
    
    // this will contain the type picker view
    lazy var textField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Reminder type"
        tf.textAlignment = .center
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.delegate = self
        
        // hides blinking cursor
        tf.tintColor = .clear
        
        return tf
    }()
    
    lazy var reminderTypePickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        
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
    
    // data source for picker view
    private var reminderTypes: [ReminderType] = [.routineTask, .refillItem, .generic]
    
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
        textLabel?.text = "Reminder type:"
        selectionStyle = .none
        contentView.addSubview(textField)
        textField.inputView = reminderTypePickerView
        textField.inputAccessoryView = toolBar
        
        textField.setAndActivateConstraints(top: safeAreaLayoutGuide.topAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, leading: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 16), size: .init(width: (frame.width / 2), height: 0))
        
    }
    
    // MARK: Utility methods
    @objc func donePicker() {
        // TODO: call delegate method to pass the contents of textfield to the VC
        textField.resignFirstResponder()
    }
}

// MARK: Text field delegate
extension ReminderTypeTableViewCell: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.text = reminderTypes.first?.rawValue
        didFinishPickingReminderTypeDelegate?.setReminderType(reminderTypes.first!)
        return true
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
        didFinishPickingReminderTypeDelegate?.setReminderType(reminderTypes[row])
    }
}
