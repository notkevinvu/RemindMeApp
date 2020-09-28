//
//  TaskViewController.swift
//  RemindMe
//
//  Created by Kevin Vu on 9/25/20.
//  Copyright © 2020 Kevin Vu. All rights reserved.
//

import UIKit
import Firebase

class RemindersViewController: UIViewController {
    
    let usersRef = Database.database().reference(withPath: "users")
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    // MARK: Setup
    private func setup() {
        let contentView = RemindersView()
        contentView.setDelegate(to: self)
        view = contentView
    }

}

extension RemindersViewController: RemindersViewDelegate {
    
    func didTapAddReminderButton() {
        print("Tapped add")
    }
    
    func didTapRemoveReminderButton() {
        print("Tapped remove")
    }
    
    
}

