//
//  SignInView.swift
//  RemindMe
//
//  Created by Kevin Vu on 12/9/20.
//  Copyright © 2020 Kevin Vu. All rights reserved.
//

import UIKit

protocol SignInDelegate: AnyObject {
    func signInView(_ signInView: SignInView, didTapSignInButtonWith credentials: TempUserCredentials, completion: @escaping () -> Void)
    func signInView(_ signInView: SignInView, didTapRegisterButtonWith credentials: TempUserCredentials, completion: @escaping () -> Void)
}

protocol PostSignInDelegate: AnyObject {
    func didFinishSigningInOrRegistering()
}

class SignInView: UIView {
    
    // MARK: - Properties
    weak var delegate: SignInDelegate?
    
    weak var postSignInDelegate: PostSignInDelegate?
    
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
//        tf.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
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
        tf.isSecureTextEntry = true
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
    init(delegate: SignInDelegate) {
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
        print("Tapped sign in button")
        guard
            let emailString = emailTextField.text,
            !emailString.isEmpty,
            isValidEmail(emailString),
            let passwordString = passwordTextField.text,
            passwordString.count >= 8
        // TODO: If the above guard statements aren't satisfied, call a function
        // to turn email/pw text fields slightly red (maybe border color)
        // to indicate an error - maybe also trigger an alert controller that
        // tells them the requirements for email and pw
        else { return }
        
        let tempUserCredentials = TempUserCredentials(email: emailString, password: passwordString)
        delegate?.signInView(self, didTapSignInButtonWith: tempUserCredentials, completion: { [weak self] in
            guard let self = self else { return }
            self.postSignInDelegate?.didFinishSigningInOrRegistering()
        })
    }
    
    @objc func didTapRegisterButton() {
        guard
            let emailString = emailTextField.text,
            !emailString.isEmpty,
            let passwordString = passwordTextField.text,
            passwordString.count >= 8
        // TODO: If the above guard statements aren't satisfied, call a function
        // to turn email/pw text fields slightly red (maybe border color)
        // to indicate an error - maybe also trigger an alert controller that
        // tells them the requirements for email and pw
        else { return }
        
        let tempUserCredentials = TempUserCredentials(email: emailString, password: passwordString)
        
        delegate?.signInView(self, didTapRegisterButtonWith: tempUserCredentials, completion: { [weak self] in
            guard let self = self else { return }
            self.postSignInDelegate?.didFinishSigningInOrRegistering()
        })
    }
    
}

// MARK: - Utility methods
extension SignInView {
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}


// MARK: - Text field delegate
extension SignInView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // we will just have the text field/keyboard resign instead of allowing
        // it to sign in users on pressing the return button on keyboard
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        // displaying red to let users know the email isnt valid
        if textField == emailTextField {
            guard let currentEmailText = textField.text else { return }
            if !isValidEmail(currentEmailText) {
                emailTextField.layer.borderWidth = 1
                emailTextField.layer.borderColor = UIColor.red.cgColor
                emailTextField.textColor = .red
            }
            
            if isValidEmail(currentEmailText) {
                emailTextField.layer.borderWidth = 0
                emailTextField.textColor = .black
            }
        }
    }
}
