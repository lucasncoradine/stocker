//
//  Validations.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 15/07/22.
//

import Foundation
import SwiftUI

// MARK: - Typealias
typealias ValidationMethod = (_ value: String) -> Bool
typealias Validations = [String: ValidationObject]

// MARK: - ValidationObject
struct ValidationObject {
    var isValid: Bool
    var message: String
}

// MARK: - Validate
/// A struct which contains multiple validation methods
struct Validate {
    static func requiredField(_ value: String) -> ValidationObject {
        let isValid: Bool = !value.isEmpty
        return ValidationObject(isValid: isValid, message: Strings.requiredField)
    }
}

// MARK: - Extensions
extension Validations {
    /// Adds a new object to the collection
    mutating func add(key: String, value: ValidationObject) {
        self[key] = value
    }
    
    /// Adds a new validation for a required field
    mutating func requiredField(key: String, value: String) {
        self[key] = Validate.requiredField(value)
    }
    
    /// Gets the value of the specific key
    func valueOf(_ key: String) -> ValidationObject? {
        return self[key]
    }
    
    /// Check if all objects are valid
    func noErrors() -> Bool {
        self.allSatisfy { $0.value.isValid == true }
    }
    
}
