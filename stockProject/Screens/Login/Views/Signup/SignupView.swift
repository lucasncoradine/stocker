//
//  SignupView.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 12/07/22.
//

import SwiftUI

struct SignupView: View {
    @StateObject var viewModel: SignupViewModel = .init()
        
    var body: some View {
        VStack(spacing: 30) {
            // Fields
            VStack(spacing: 20) {
                TextField("Nome", text: $viewModel.name)
                    .textContentType(.name)
                    .textFieldStyle(.roundedBorder)
                    .fieldError(viewModel.nameValidationMessage)
                
                TextField("Email", text: $viewModel.email)
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.emailAddress)
                    .fieldError(viewModel.emailValidationMessage)
                
                SecureField("Senha", text: $viewModel.password)
                    .textContentType(.newPassword)
                    .textFieldStyle(.roundedBorder)
                    .fieldError(viewModel.passwordValidationMessage)
                
                SecureField("Confirmar senha", text: $viewModel.confirmPassword)
                    .textContentType(.newPassword)
                    .textFieldStyle(.roundedBorder)
                    .fieldError(viewModel.confirmPasswordValidationMessage)
            }
            
            // Signup Button
            CustomButton(action: viewModel.createAccout, showLoading: viewModel.isLoading, type: .primaryGradient) {
                Text("Criar conta")
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Nova conta")
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SignupView()
        }
    }
}
