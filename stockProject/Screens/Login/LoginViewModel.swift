//
//  LoginViewModel.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 12/07/22.
//

import Foundation

class LoginViewModel: ObservableObject {
    private let client: AuthManager = .init()
    
    @Published var email: String = ""
    @Published var emailValidationMessage: String = ""
    @Published var password: String = ""
    @Published var passwordValidationMessage: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    
    private func requestFailed(_ message: String) {
        isLoading = false
        errorMessage = message
        showError = true
    }
    
    // MARK: - Private Methods
    private func validateFields() -> Bool {
        emailValidationMessage = Validations.validateEmail(self.email).message
        passwordValidationMessage = Validations.validateRequiredField(fieldName: "Senha", value: self.password).message
        
        let validations  = [
            emailValidationMessage,
            passwordValidationMessage
        ]
        
        return validations.allSatisfy { $0.isEmpty }
    }
    
    // MARK: - Methods
    func login() {
        if validateFields() {
            isLoading = true
            
            client.authenticate(withEmail: self.email, withPassword: self.password) { user in
                self.isLoading = false
            }
        }
    }
}
