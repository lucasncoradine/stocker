//
//  FormViewModelProtocol.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 18/07/22.
//

import Foundation

protocol FormViewModelProtocol: ObservableObject {
    var validations: Validations { get set }
    var isLoading: Bool { get set }
    var showError: Bool { get set }
    var errorMessage: String { get set }
    
    func requestFailed(_ message: String)
    func validateFields() -> Bool
}

extension FormViewModelProtocol {
    func requestFailed(_ message: String) {
        self.isLoading = false
        self.showError = true
        self.errorMessage = message
    }
}

protocol FormViewModelField {
    var description: String { get }
}
