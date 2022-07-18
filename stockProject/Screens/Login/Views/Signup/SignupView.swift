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
                TextField(Strings.name, text: $viewModel.name)
                    .textContentType(.name)
                    .textFieldStyle(.roundedBorder)
                    .validation(viewModel.validations.valueOf(SignupField.name.description))
                
                TextField(Strings.email, text: $viewModel.email)
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.emailAddress)
                    .validation(viewModel.validations.valueOf(SignupField.email.description))
                
                SecureField(Strings.password, text: $viewModel.password)
                    .textContentType(.newPassword)
                    .textFieldStyle(.roundedBorder)
                    .validation(viewModel.validations.valueOf(SignupField.password.description))
                
                SecureField(Strings.confirmPassword, text: $viewModel.confirmPassword)
                    .textContentType(.newPassword)
                    .textFieldStyle(.roundedBorder)
                    .validation(viewModel.validations.valueOf(SignupField.confirmPassword.description))
            }
            
            // Signup Button
            CustomButton(action: viewModel.createAccout, showLoading: viewModel.isLoading, type: .primaryGradient) {
                Text(Strings.signupButton)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle(Strings.signupNavigationTitle)
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SignupView()
        }
    }
}
