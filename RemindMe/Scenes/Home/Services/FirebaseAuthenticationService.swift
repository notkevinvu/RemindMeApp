//
//  FirebaseHandlerService.swift
//  RemindMe
//
//  Created by Kevin Vu on 11/24/20.
//  Copyright © 2020 Kevin Vu. All rights reserved.
//

import Foundation
import Firebase

class FirebaseAuthenticationService {
    
    // MARK: - Properties
    // firebase docs suggest to remove the auth handle in viewWillDisappear
    // so we keep the auth handle optional to handle a nil state
    var authHandle: AuthStateDidChangeListenerHandle? = nil
    
    // MARK: - Private methods
    private func signInAnonymously() {
        Auth.auth().signInAnonymously { (authResult, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            // only need to sign in here, we will set the user
            // via the authenticate user
        }
    }
    
    private func addAuthListener(completion: @escaping (User) -> Void) {
        authHandle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            guard let user = user else { return }
            
            let currentUser = User(authData: user)
            // use completion to set the current user
            completion(currentUser)
        })
    }
    
    // MARK: - Public methods
    public func authenticateUser(completion: @escaping (User) -> Void) {
        if Auth.auth().currentUser == nil {
            signInAnonymously()
        }
        addAuthListener { (user) in
            // use completion to add reference observer after
            // authenticating users
            completion(user)
        }
    }
    
    public func removeAuthListener() {
        guard let authHandle = authHandle else { return }
        Auth.auth().removeStateDidChangeListener(authHandle)
    }
    
}
