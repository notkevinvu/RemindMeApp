//
//  IntervalTimeTableViewCell.swift
//  RemindMe
//
//  Created by Kevin Vu on 11/4/20.
//  Copyright © 2020 Kevin Vu. All rights reserved.
//

import UIKit

protocol IntervalTimeCellDelegate: class {
    func setIntervalTime(type: ReminderIntervalTimeType, value: Int)
}

class IntervalTimeTableViewCell: UITableViewCell {
    
    // MARK: - Constants
    static let identifier = "IntervalTimeCellID"
    
    // MARK: - Properties
    weak var didFinishPickingIntervalTimeDelegate: IntervalTimeCellDelegate?
    
    let discreteTimeUnits = Array(0...365)
    let intervalTimeTypes: [ReminderIntervalTimeType] = [.days, .weeks, .months, .years]
    
    lazy var textField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Interval time"
        tf.textAlignment = .center
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.delegate = self
        
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
    
    // TODO: Maybe use two picker views? Kind of hard atm to update textfield
    // with multiple components in pickerview
    lazy var intervalTimePicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()
    
    // MARK: - Object lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init?(coder:) is not implemented")
    }
    
    // MARK: - Setup
    private func setup() {
        textLabel?.text = "Interval time:"
        selectionStyle = .none
        contentView.addSubview(textField)
        textField.inputAccessoryView = intervalTimePicker
        
        textField.setAndActivateConstraints(top: safeAreaLayoutGuide.topAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, leading: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 16), size: .init(width: (frame.width/2), height: 0))
    }
    
    // MARK: - Toolbar button methods
    @objc func handleCancelButtonTap() {
        // TODO: Reset textfield
        textField.text = ""
        textField.resignFirstResponder()
    }
    
    @objc func handleDoneButtonTap() {
        textField.resignFirstResponder()
    }
}

// MARK: - Textfield delegate
extension IntervalTimeTableViewCell: UITextFieldDelegate {
    
}

// MARK: - Pickerview delegate
extension IntervalTimeTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return discreteTimeUnits.count
        } else {
            return intervalTimeTypes.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return String(discreteTimeUnits[row])
        } else {
            return intervalTimeTypes[row].rawValue
        }
    }
    
    
}
