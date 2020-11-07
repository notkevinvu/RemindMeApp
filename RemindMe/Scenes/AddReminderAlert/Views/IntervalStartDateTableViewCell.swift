//
//  IntervalStartDateTableViewCell.swift
//  RemindMe
//
//  Created by Kevin Vu on 10/30/20.
//  Copyright © 2020 Kevin Vu. All rights reserved.
//

import UIKit

protocol IntervalStartDateCellDelegate: class {
    func setIntervalStartDate(_ date: Date)
}

class IntervalStartDateTableViewCell: UITableViewCell {
    
    // MARK: Constants
    static let identifier = "IntervalStartDateTableViewCell"
    
    
    // MARK: Properties
    weak var didFinishPickingIntervalStartDateDelegate: IntervalStartDateCellDelegate?
    // use this date as default start point for textfield date, and update when
    // the user scrolls through picker view, while also keeping placeholder in
    // text field
    var currentDate: Date = Date()
    var previousConfirmedDate: Date = Date()
    
    // this contains the date picker view
    lazy var textField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Reminder start date"
        tf.textAlignment = .center
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.delegate = self
        // remove blinking cursor
        tf.tintColor = .clear
        
        // toolbar to confirm after using date picker
        let toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.sizeToFit()
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancelButtonTap))
        cancelButton.tintColor = .systemRed
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(handleDoneButtonTap))
        
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        
        tf.inputAccessoryView = toolbar
        
        return tf
    }()
    
    lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date()
        datePicker.addTarget(self, action: #selector(didChangeDatePickerValue), for: .valueChanged)
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
    private func getFormattedStringFromDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
    
    @objc func handleCancelButtonTap() {
        // we set both dates back to the previous confirmed date so that when
        // the textfield's shouldEndEditing method gets called,
        datePicker.date = previousConfirmedDate
        currentDate = previousConfirmedDate
        textField.text = getFormattedStringFromDate(currentDate)
        textField.resignFirstResponder()
    }
    
    @objc func handleDoneButtonTap() {
        // dates will be set in textFieldShouldEndEditing,
        textField.text = getFormattedStringFromDate(datePicker.date)
        textField.resignFirstResponder()
    }
    
    @objc func didChangeDatePickerValue(_ sender: UIDatePicker) {
        textField.text = getFormattedStringFromDate(sender.date)
    }
    
}

// MARK: Text field delegate
extension IntervalStartDateTableViewCell: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.text = getFormattedStringFromDate(currentDate)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        currentDate = datePicker.date
        previousConfirmedDate = datePicker.date
        didFinishPickingIntervalStartDateDelegate?.setIntervalStartDate(currentDate)
        return true
    }
}
