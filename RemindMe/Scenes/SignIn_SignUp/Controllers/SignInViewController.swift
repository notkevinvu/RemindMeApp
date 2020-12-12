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
    
    // MARK: - Object lifecycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
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
        let view = SignInView(delegate: self)
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

// MARK: - Sign in view delegate
extension SignInViewController: SignInViewDelegate {
    func didTapSignUpButton() {
        
    }
    
    func didTapSignInButton() {
        
    }
    
    
}
