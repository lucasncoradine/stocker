//
//  PasswordRecoverViewModel.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 19/07/22.
//

import Foundation

enum PasswordRecoverFields: FormViewModelField {
    case email
    
    var description: String {
        switch self {
        case .email:
            return Strings.email
        }
    }
}

class PasswordRecoverViewModel: FormViewModelProtocol {
    @Published var validations: Validations = [:]
    @Published var isLoading: Bool = false
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    @Published var email: String
    @Published var emailSent: Bool = false
    
    init(with email: String = "") {
        self.email = email
    }
    
    func validateFields() -> Bool {
        validations.add(key: PasswordRecoverFields.email.description, value: Validate.email(self.email))
        
        return validations.noErrors()
    }
    
    func sendEmail() {
        guard validateFields() else { return }
        
        isLoading = true
        
        AuthManager.shared.sendPasswordReset(to: self.email, failure: self.requestFailed) {
            self.emailSent = true
            self.isLoading = false
        }
    }
    
}
