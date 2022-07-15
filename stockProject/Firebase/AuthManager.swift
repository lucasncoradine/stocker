//
//  AuthenticationClient.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 14/07/22.
//

import Foundation
import FirebaseAuth
import SwiftUI

struct AuthManagerShared {
    var user: FirebaseUser? = Auth.auth().currentUser
}

class AuthManager: ObservableObject {
    private let auth: Auth = Auth.auth()
    private var listener: AuthStateDidChangeListenerHandle? = nil
    static var shared: AuthManagerShared = .init()
    
    @Published var isUserAuthenticated: Bool
    
    init() {
        self._isUserAuthenticated = .init(wrappedValue: auth.currentUser != nil)
        
        listener = auth.addStateDidChangeListener { _, user in
            self.isUserAuthenticated = user != nil
        }
    }
    
    deinit {
        if let listener = listener {
            auth.removeStateDidChangeListener(listener)
        }
    }
    
    /// Authenticate the user with `email` and `password`
    /// - parameter wiwthEmail: The email of the user
    /// - parameter withPassword: The password ot the user
    /// - parameter completion: A closure to handle the result of this request
    func authenticate(withEmail: String,
                      withPassword: String,
                      completion: @escaping (_ result: Result<FirebaseUser, Error>) -> Void
    ) {
        auth.signIn(withEmail: withEmail, password: withPassword) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let result = result else {
                completion(.failure(FirebaseError.noUser))
                return
            }
            
            completion(.success(result.user))
        }
    }
    
    /// Signs out the user with
    func signOut() {
        do {
            try auth.signOut()
        } catch let signOutError {
            print(signOutError.localizedDescription)
        }
    }
    
    /// Create a new user
    func signUp(email: String,
                password: String,
                name: String?,
                completion: @escaping (_ result: Result<FirebaseUser, Error>) -> Void
    ) {
        auth.createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            }
            
            guard let authResult = authResult else {
                completion(.failure(FirebaseError.noUser))
                return
            }
            
            let changeRequest = authResult.user.createProfileChangeRequest()
            changeRequest.displayName = name
            changeRequest.commitChanges { error in
                if let error = error {
                    completion(.failure(error))
                }
            }
            
            completion(.success(authResult.user))
        }
    }
}
