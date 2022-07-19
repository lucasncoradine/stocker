//
//  AuthenticationClient.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 14/07/22.
//

import FirebaseAuth
import SwiftUI

class AuthManager: ObservableObject {
    // MARK: - Shared
    static var shared: AuthManager = .init()
    
    // MARK: - Lifecycle
    private let client: FirebaseClient = .init()
    private let auth: Auth = Auth.auth()
    private var listener: AuthStateDidChangeListenerHandle? = nil
    
    var user: FirebaseUser? {
        auth.currentUser
    }
    
    @Published var isUserAuthenticated: Bool
    @Published var isSigninUp: Bool = false
    
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
    
    // MARK: - Methods
    
    /// Authenticate the user with `email` and `password`
    /// - parameter wiwthEmail: The email of the user
    /// - parameter withPassword: The password ot the user
    /// - parameter completion: A closure to handle the result of this request
    func authenticate(withEmail: String,
                      withPassword: String,
                      failure: @escaping FailureClosure,
                      success: @escaping (_ user: FirebaseUser) -> Void
    ) {
        auth.signIn(withEmail: withEmail, password: withPassword) { result, error in
            if let error = error {
                failure(self.client.handleError(error))
                return
            }
            
            if let result = result {
                success(result.user)
            }
        }
    }
    
    /// Signs out the user
    func signOut() {
        do {
            try auth.signOut()
        } catch let signOutError {
            print(signOutError.localizedDescription)
        }
    }
    
    /// Create a new user with email
    /// - parameters:
    ///  - email: The user Email
    ///  - password: The user password
    ///  - name: The user name
    ///  - completion: A closure to handle the request
    func signUp(email: String,
                password: String,
                name: String?,
                failure: @escaping FailureClosure,
                success: @escaping (_ user: FirebaseUser) -> Void
    ) {
        auth.createUser(withEmail: email, password: password) { authResult, error in
            guard error == nil,
                  let authResult = authResult
            else {
                failure(self.client.handleError(error ?? FirebaseError.noUser))
                return
            }
            
            let changeRequest = authResult.user.createProfileChangeRequest()
            changeRequest.displayName = name
            changeRequest.commitChanges { error in
                if let error = error {
                    failure(self.client.handleError(error))
                    return
                }
            }
            
            success(authResult.user)
        }
    }
}
