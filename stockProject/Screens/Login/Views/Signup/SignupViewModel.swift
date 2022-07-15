//
//  SignupViewModel.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 12/07/22.
//

import Foundation

class SignupViewModel: ObservableObject {
    private let auth: AuthManager = .init()
    
    @Published var name: String = ""
    @Published var nameValidationMessage: String = ""
    @Published var email: String = ""
    @Published var emailValidationMessage: String = ""
    @Published var password: String = ""
    @Published var passwordValidationMessage: String = ""
    @Published var confirmPassword: String = ""
    @Published var confirmPasswordValidationMessage: String = ""
    @Published var isLoading: Bool = false
    @Published var userCreated: Bool = false
    
    // MARK: - Private Methods
    private func validateFields() -> Bool {
        nameValidationMessage = Validations.validateRequiredField(fieldName: "Nome", value: self.name).message
        emailValidationMessage = Validations.validateEmail(self.email).message
        passwordValidationMessage = Validations.validateRequiredField(fieldName: "Senha", value: self.password).message
        confirmPasswordValidationMessage = Validations.validateConfirmPassword(password: self.password,
                                                                               confirmPassword: self.confirmPassword).message
        
        let validations  = [
            nameValidationMessage,
            emailValidationMessage,
            passwordValidationMessage,
            confirmPasswordValidationMessage
        ]
        
        return validations.allSatisfy { $0.isEmpty }
    }
    
    // MARK: - Public Methods
    func createAccout() {
        if validateFields() {
            self.isLoading = true
            
            auth.signUp(email: self.email, password: self.password, name: self.name) { _ in
                self.isLoading = false
                self.userCreated = true
            }
        }
    }
}
