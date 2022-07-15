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
            CustomButton(action: viewModel.createAccout, showLoading: viewModel.isLoading) {
                Text("Criar conta")
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Nova conta")
        .alert("Usuário criado com sucesso", isPresented: $viewModel.userCreated) {
            Button(role: .cancel, action: {}) {
                Text("OK")
            }
        }
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SignupView()
        }
    }
}
