//
//  RemindersViewController.swift
//  RemindMe
//
//  Created by Kevin Vu on 9/28/20.
//  Copyright © 2020 Kevin Vu. All rights reserved.
//

import UIKit

class RemindersView: UIView {
    
    // MARK: Properties and Constants
    
    // MARK: UI Properties
    
    lazy var remindersTableView: UITableView = {
        let table = UITableView()
        // default inset extends past trailing edge; this creates a symmetric separator
        table.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        table.separatorColor = .darkGray
        table.backgroundColor = .white
        table.register(RemindersTableViewCell.self, forCellReuseIdentifier: RemindersTableViewCell.cellID)
        return table
    }()
    
    // MARK: Object lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    // MARK: Setup
    private func setup() {
        backgroundColor = .white
        
        addSubview(remindersTableView)
        
        remindersTableView.setAndActivateConstraints(top: safeAreaLayoutGuide.topAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, centerX: nil, centerY: nil)
    }
    
}
