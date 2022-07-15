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
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    
    private func requestFailed(_ message: String) {
        isLoading = false
        errorMessage = message
        showError = true
    }
    
    // MARK: - Methods
    func login() {
        isLoading = true
        
        client.authenticate(withEmail: self.email, withPassword: self.password) { user in
            self.isLoading = false
        }
    }
}
