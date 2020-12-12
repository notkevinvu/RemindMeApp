//
//  SignInView.swift
//  RemindMe
//
//  Created by Kevin Vu on 12/9/20.
//  Copyright © 2020 Kevin Vu. All rights reserved.
//

import UIKit

protocol SignInViewDelegate: AnyObject {
    func didTapSignUpButton()
    func didTapSignInButton()
}

class SignInView: UIView {
    
    // MARK: - Properties
    weak var delegate: SignInViewDelegate?
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .fill
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    lazy var emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email..."
        tf.adjustsFontSizeToFitWidth = true
        tf.textAlignment = .center
        tf.translatesAutoresizingMaskIntoConstraints = false
        
        tf.backgroundColor = .green
        
        return tf
    }()
    
    lazy var passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password..."
        tf.textAlignment = .center
        tf.adjustsFontSizeToFitWidth = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        
        tf.backgroundColor = .red
        
        return tf
    }()
    
    lazy var buttonStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .fill
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 20
        
        return stack
    }()
    
    lazy var signInButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleLabel?.text = "Sign In"
        btn.layer.cornerRadius = 5
        
        btn.backgroundColor = .blue
        
        return btn
    }()
    
    lazy var signUpButton: UIButton = {
        let btn = UIButton()
        // TODO: Assign an action to navigate to a signup screen (probably
        // gonna be similar to this screen; needs email and 2x password fields
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleLabel?.text = "Sign Up"
        btn.layer.cornerRadius = 5
        
        btn.backgroundColor = .orange
        
        return btn
    }()
    
    // MARK: - Object lifecycle
    init(delegate: SignInViewDelegate) {
        super.init(frame: .zero)
        self.delegate = delegate
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup methods
    
    private func setup() {
        backgroundColor = .systemBackground
        
        addSubview(stackView)
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(passwordTextField)
        
        buttonStackView.addArrangedSubview(signUpButton)
        buttonStackView.addArrangedSubview(signInButton)
        stackView.addArrangedSubview(buttonStackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: centerYAnchor, constant: -150),
            stackView.bottomAnchor.constraint(equalTo: centerYAnchor, constant: 100),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 75),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -75)
            // stack view configuration automatically resizes its arranged
            // subviews, so we don't need to deal with the anchors ourselves
        ])
        
    }
    
}
