//
//  ViewModelProtocol.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 21/07/22.
//

import Foundation

protocol ViewModel: ObservableObject {
    var isLoading: Bool { get set }
    var showError: Bool { get set }
    var errorMessage: String { get set }
    
    func requestFailed(_ message: String)
}

extension ViewModel {
    func requestFailed(_ message: String) {
        self.isLoading = false
        self.showError = true
        self.errorMessage = message
    }
}
