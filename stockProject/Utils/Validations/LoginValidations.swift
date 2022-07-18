//
//  LoginValidations.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 15/07/22.
//

import Foundation

extension Validate {
    static func email(_ email: String) -> ValidationObject {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let isValid = emailPred.evaluate(with: email)
        
        return ValidationObject(isValid: isValid, message: Strings.invalidEmail)
    }
    
    static func confirmPassword(password: String, confirmPassword: String) -> ValidationObject {
        let isValid = password == confirmPassword
        return ValidationObject(isValid: isValid, message: Strings.passwordsDontMatch)
    }
}


