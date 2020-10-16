//
//  CustomAlertView.swift
//  RemindMe
//
//  Created by Kevin Vu on 10/14/20.
//  Copyright © 2020 Kevin Vu. All rights reserved.
//

import UIKit

class AddReminderAlertView: UIView {
    
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
        backgroundColor = .red
        
//        setAndActivateConstraints(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor)
    }
}
