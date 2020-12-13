//
//  SignInView.swift
//  RemindMe
//
//  Created by Kevin Vu on 12/9/20.
//  Copyright © 2020 Kevin Vu. All rights reserved.
//

import UIKit

protocol SignInViewDelegate: AnyObject {
    func signInView(_ signInView: SignInView, shouldSignInWith credentials: TempUserCredentials)
    func signInView(_ signInView: SignInView, shouldRegisterWith credentials: TempUserCredentials)
}

class SignInView: UIView {
    
    // MARK: - Properties
    weak var delegate: SignInViewDelegate?
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .fill
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 25
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    lazy var emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email..."
        tf.adjustsFontSizeToFitWidth = true
        tf.textAlignment = .center
        tf.delegate = self
        tf.translatesAutoresizingMaskIntoConstraints = false
        
        tf.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        
        return tf
    }()
    
    lazy var passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password..."
        tf.textAlignment = .center
        tf.adjustsFontSizeToFitWidth = true
        tf.delegate = self
        tf.translatesAutoresizingMaskIntoConstraints = false
        
        tf.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        
        return tf
    }()
    
    lazy var signInButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("SIGN IN", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.addTarget(self, action: #selector(didTapSignInButton), for: .touchUpInside)
        
        btn.backgroundColor = .green
        
        return btn
    }()
    
    lazy var registerButton: UIButton = {
        let btn = UIButton()
        // TODO: Assign an action to navigate to a signup screen (probably
        // gonna be similar to this screen; needs email and 2x password fields
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("REGISTER FOR FREE", for: .normal)
        btn.layer.borderWidth = 1
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.addTarget(self, action: #selector(didTapRegisterButton), for: .touchUpInside)
        
        btn.backgroundColor = .clear
        
        return btn
    }()
    
    // MARK: - Object lifecycle
    init(delegate: SignInViewDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        configureButtonViewsAfterInitialization()
    }
    
    // MARK: - Setup methods
    private func configureButtonViewsAfterInitialization() {
        signInButton.layer.cornerRadius = signInButton.bounds.height / 2
        registerButton.layer.cornerRadius = registerButton.bounds.height / 2
    }
    
    private func setup() {
        backgroundColor = .systemBackground
        
        addSubview(stackView)
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(signInButton)
        stackView.addArrangedSubview(registerButton)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: centerYAnchor, constant: -125),
            stackView.bottomAnchor.constraint(equalTo: centerYAnchor, constant: 150),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50)
            // stack view configuration automatically resizes its arranged
            // subviews, so we don't need to deal with the anchors ourselves
        ])
        
        layoutIfNeeded()
    }
    
    // MARK: - Button methods
    @objc func didTapSignInButton() {
        print("SIGN IN BUTTON TAPPED")
        guard
            let emailString = emailTextField.text,
            !emailString.isEmpty,
            let passwordString = passwordTextField.text,
            passwordString.count >= 8
        // TODO: If the above guard statements aren't satisfied, call a function
        // to turn email/pw text fields slightly red (maybe border color)
        // to indicate an error - maybe also trigger an alert controller that
        // tells them the requirements for email and pw
        else {
            print("ERROR SIGN IN")
            return }
        
        let tempUserCredentials = TempUserCredentials(email: emailString, password: passwordString)
        delegate?.signInView(self, shouldSignInWith: tempUserCredentials)
    }
    
    @objc func didTapRegisterButton() {
        print("REGISTER BUTTON TAPPED")
        guard
            let emailString = emailTextField.text,
            !emailString.isEmpty,
            let passwordString = passwordTextField.text,
            passwordString.count >= 8
        // TODO: If the above guard statements aren't satisfied, call a function
        // to turn email/pw text fields slightly red (maybe border color)
        // to indicate an error - maybe also trigger an alert controller that
        // tells them the requirements for email and pw
        else {
            print("ERROR REGISTER")
            return }
        
        let tempUserCredentials = TempUserCredentials(email: emailString, password: passwordString)
        print(tempUserCredentials.email)
        
        delegate?.signInView(self, shouldRegisterWith: tempUserCredentials)
    }
    
}

// MARK: - Text field delegate
extension SignInView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == passwordTextField {
            // perform sign in function here
        }
        textField.resignFirstResponder()
        return true
    }
}
