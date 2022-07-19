//
//  LoginViewModel.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 12/07/22.
//

import Foundation

enum LoginField: FormViewModelField {
    case email
    case password
    
    var description: String {
        switch self {
        case .email: return Strings.email
        case .password: return Strings.password
        }
    }
}

class LoginViewModel: FormViewModelProtocol {
    private let authManager: AuthManager = .init()
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    @Published var validations: Validations = [:]
    @Published var showRecoverSheet: Bool = false
    
    func validateFields() -> Bool {
        validations.add(key: LoginField.email.description, value: Validate.email(self.email))
        validations.requiredField(key: LoginField.password.description, value: self.password)
        
        return validations.noErrors()
    }
    
    // MARK: - Methods
    func login() {
        if validateFields() {
            isLoading = true
            
            authManager.authenticate(withEmail: self.email, withPassword: self.password, failure: self.requestFailed) { _ in
                self.isLoading = false
            }
        }
    }
}
