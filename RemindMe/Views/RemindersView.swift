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
    
    lazy var remindersTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.layer.borderWidth = 1
        table.layer.cornerRadius = 10
        
        // default inset extends past trailing edge; this creates a symmetric separator
        table.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        table.separatorColor = .darkGray
        table.backgroundColor = .white
        
        // TODO: HOok up table view to show reminder items, then hook up
        // the firebase add/remove value methods to nav button and swipe action
        // respectively
        
        table.register(RemindersTableViewCell.self, forCellReuseIdentifier: RemindersTableViewCell.cellID)
        
        return table
    }()
    
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
        
        addSubview(remindersTableView)
        
        NSLayoutConstraint.activate([
            remindersTableView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            remindersTableView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            remindersTableView.heightAnchor.constraint(lessThanOrEqualToConstant: 600),
            remindersTableView.widthAnchor.constraint(equalToConstant: 300)
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
