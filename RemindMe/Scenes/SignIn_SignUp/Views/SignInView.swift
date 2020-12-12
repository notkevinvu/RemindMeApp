//
//  SignInView.swift
//  RemindMe
//
//  Created by Kevin Vu on 12/9/20.
//  Copyright © 2020 Kevin Vu. All rights reserved.
//

import UIKit

class SignInView: UIView {
    
    // MARK: - Properties
    lazy var emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email..."
        
        return tf
    }()
    
    lazy var passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password..."
        
        return tf
    }()
    
    lazy var signInButton: UIButton = {
        let btn = UIButton()
        
        return btn
    }()
    
    lazy var signUpButton: UIButton = {
        let btn = UIButton()
        // TODO: Assign an action to navigate to a signup screen (probably
        // gonna be similar to this screen; needs email and 2x password fields
        
        return btn
    }()
    
    // MARK: - Object lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Setup methods
    
    private func setup() {
        addSubviews([emailTextField,
                     passwordTextField,
                     signInButton,
                     signUpButton])
        
        // TODO: Set up constraints
    }
    
}
