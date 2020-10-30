//
//  IntervalStartDateTableViewCell.swift
//  RemindMe
//
//  Created by Kevin Vu on 10/30/20.
//  Copyright © 2020 Kevin Vu. All rights reserved.
//

import UIKit

class IntervalStartDateTableViewCell: UITableViewCell {
    
    // MARK: Constants
    static let identifier = "IntervalStartDateTableViewCell"
    
    
    // MARK: UI Properties
    // this contains the date picker view
    lazy var textField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Reminder start date"
        tf.textAlignment = .center
        tf.font = UIFont.systemFont(ofSize: 16)
        
        tf.tintColor = .clear
        
        // toolbar to confirm after using date picker
        let toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.sizeToFit()
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancelButtonTap))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(handleDoneButtonTap))
        
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        
        tf.inputAccessoryView = toolbar
        
        return tf
    }()
    
    lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        
        return datePicker
    }()
    
    // MARK: Object lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init?(coder:) is not implemented")
    }
    
    // MARK: View lifecycle(?)
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // MARK: Setup
    private func setup() {
        textLabel?.text = "Reminder start date:"
        selectionStyle = .none
        contentView.addSubview(textField)
        textField.inputView = datePicker
        
        textField.setAndActivateConstraints(top: safeAreaLayoutGuide.topAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, leading: nil, trailing: trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 16), size: .init(width: (frame.width / 2), height: 0))
    }
    
    // MARK: Utility methods
    @objc func handleCancelButtonTap() {
        // reset date picker - ideally, we want to reset this to whatever the previous date was
        datePicker.date = Date()
        textField.resignFirstResponder()
    }
    
    @objc func handleDoneButtonTap() {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        textField.text = formatter.string(from: datePicker.date)
        // TODO: delegate method to send the date into the VC to set the reminder item
        // object's interval start date
        textField.resignFirstResponder()
    }
    
}
