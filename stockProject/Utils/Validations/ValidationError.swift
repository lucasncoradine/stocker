//
//  ValidationError.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 15/07/22.
//

import Foundation

enum ValidationError {
    case emptyField(fieldName: String)
    case invalidEmail
    case passwordsDontMatch
    case none
    
    var message: String {
        switch self {
        case .emptyField(let fieldName): return "O campo \(fieldName) é obrigatório"
        case .invalidEmail: return "Email inválido"
        case .passwordsDontMatch: return "As senhas não são iguais"
        default: return ""
        }
    }
}
