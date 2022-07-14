//
//  LoginViewModel.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 12/07/22.
//

import Foundation

class LoginViewModel: ObservableObject {
    // client
    
    @Published var email: String = ""
    @Published var password: String = ""
}
