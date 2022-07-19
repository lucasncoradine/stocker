//
//  SignupViewModel.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 12/07/22.
//

import Foundation

enum SignupField: FormViewModelField {
    case name
    case email
    case password
    case confirmPassword
    
    var description: String {
        switch self {
        case .name: return Strings.name
        case .email: return Strings.email
        case .password: return Strings.password
        case .confirmPassword: return Strings.confirmPassword
        }
    }
}

class SignupViewModel: FormViewModel {
    private let auth: AuthManager = .init()
    
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var isLoading: Bool = false
    @Published var validations: Validations = [:]
    
    func requestFailed(_ message: String) {
        // TODO: Error message
    }
    
    func validateFields() -> Bool {
        validations.requiredField(key: SignupField.name.description, value: self.name)
        validations.add(key: SignupField.email.description, value: Validate.email(self.email))
        validations.requiredField(key: SignupField.password.description, value: self.password)
        validations.add(key: SignupField.confirmPassword.description,
                        value: Validate.confirmPassword(password: self.password,
                                                        confirmPassword: self.confirmPassword))
        
        return validations.noErrors()
    }
    
    // MARK: - Public Methods
    func createAccout() {
        if validateFields() {
            self.isLoading = true
            
            auth.signUp(email: self.email, password: self.password, name: self.name) { _ in
                self.isLoading = false
            }
        }
    }
}
