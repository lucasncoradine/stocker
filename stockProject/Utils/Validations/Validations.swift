//
//  Validations.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 15/07/22.
//

import Foundation

struct FieldValidation {
    let value: String
    let error: ValidationError
    let completion: (_ message: String) -> Void
}

struct Validations {
    static func validate(_ condition: Bool, error: ValidationError) -> ValidationError {
        return condition ? .none : error
    }
    
    static func validateRequiredField(fieldName: String, value: String) -> ValidationError {
        return validate(!value.isEmpty, error: .emptyField(fieldName: fieldName))
    }
}
