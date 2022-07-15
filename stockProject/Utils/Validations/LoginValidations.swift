//
//  LoginValidations.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 15/07/22.
//

import Foundation

extension Validations {
    static func validateEmail(_ email: String) -> ValidationError {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        let isValidEmail: Bool = emailPred.evaluate(with: email)
        
        return validate(isValidEmail, error: .invalidEmail)
    }
    
    static func validateConfirmPassword(password: String, confirmPassword: String) -> ValidationError {
        let areEqual: Bool = password == confirmPassword
        return validate(areEqual, error: .passwordsDontMatch)
    }
}


