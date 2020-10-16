//
//  CustomAlertViewController.swift
//  RemindMe
//
//  Created by Kevin Vu on 10/14/20.
//  Copyright © 2020 Kevin Vu. All rights reserved.
//

import UIKit

class CustomAlertViewController: UIViewController {
    
    var contentView: CustomAlertView!
    
    // MARK: Object lifecycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    // MARK: View lifecycle
    override func loadView() {
        super.loadView()
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    // MARK: Setup
    private func setup() {
        let view = CustomAlertView()
        contentView = view
    }
    
}
