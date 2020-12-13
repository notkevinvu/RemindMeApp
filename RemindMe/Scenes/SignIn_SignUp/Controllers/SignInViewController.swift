//
//  SignInViewController.swift
//  RemindMe
//
//  Created by Kevin Vu on 12/9/20.
//  Copyright © 2020 Kevin Vu. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    
    // MARK: - Properties
    var contentView: SignInView!
    
    weak var delegate: SignInViewDelegate?
    
    // MARK: - Object lifecycle
    
    init(delegate: SignInViewDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - View lifecycle
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Setup
    private func setupView() {
        // we should have a delegate by this time anyway since we inject a delegate
        // into the current VC on initialization. Thus, we can force cast the delegate
        // to inject into the view
        let view = SignInView(delegate: delegate!)
        contentView = view
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "Sign In"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapCancelButton))
        navigationItem.leftBarButtonItem?.tintColor = .systemRed
    }
    
    private func setup() {
        setupView()
        configureNavigationBar()
    }
    
    // MARK: - Button methods
    @objc func didTapCancelButton() {
        dismiss(animated: true, completion: nil)
    }
    
}
