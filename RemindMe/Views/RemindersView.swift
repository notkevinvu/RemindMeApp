//
//  RemindersViewController.swift
//  RemindMe
//
//  Created by Kevin Vu on 9/28/20.
//  Copyright © 2020 Kevin Vu. All rights reserved.
//

import UIKit

protocol RemindersViewDelegate: class {
    func didTapAddReminderButton()
    func didTapRemoveReminderButton()
}

class RemindersView: UIView {
    
    // MARK: Properties and Constants
    
    weak var delegate: RemindersViewDelegate?
    
    // MARK: UI Properties
    
    lazy var addReminderButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.cornerRadius = 5
        btn.backgroundColor = .green
        btn.layer.borderWidth = 1
        
        btn.setImage(UIImage(systemName: "plus.app"), for: .normal)
        btn.contentMode = .scaleAspectFit
        btn.tintColor = .black
        
        btn.addTarget(self, action: #selector(didTapAddReminderButton(sender:)), for: .touchUpInside)
        
        return btn
    }()
    
    lazy var removeReminderButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.cornerRadius = 5
        btn.backgroundColor = .red
        btn.layer.borderWidth = 1
        
        btn.setImage(UIImage(systemName: "minus.square"), for: .normal)
        btn.contentMode = .scaleAspectFit
        btn.tintColor = .black
        
        btn.addTarget(self, action: #selector(didTapRemoveReminderButton(sender:)), for: .touchUpInside)
        
        return btn
    }()
    
    // MARK: Object lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup
    private func setup() {
        backgroundColor = .white
        
        addSubview(addReminderButton)
        addSubview(removeReminderButton)
        
        NSLayoutConstraint.activate([
            addReminderButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            addReminderButton.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: -100),
            addReminderButton.heightAnchor.constraint(equalToConstant: 100),
            addReminderButton.widthAnchor.constraint(equalToConstant: 100),
            
            removeReminderButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            removeReminderButton.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 100),
            removeReminderButton.heightAnchor.constraint(equalToConstant: 100),
            removeReminderButton.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    func setDelegate(to delegate: RemindersViewDelegate) {
        self.delegate = delegate
    }
    
    
    // MARK: Button methods
    
    @objc func didTapAddReminderButton(sender: UIButton) {
        delegate?.didTapAddReminderButton()
    }
    
    @objc func didTapRemoveReminderButton(sender: UIButton) {
        delegate?.didTapRemoveReminderButton()
    }
    
}
