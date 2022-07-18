//
//  LoginView.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 12/07/22.
//

import SwiftUI

struct LoginView: View {
    @StateObject var viewModel: LoginViewModel = .init()
        
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                // APP Icon
                Image("Icon")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 60)
                    .padding(.bottom, 40)
                
                // Fields
                VStack(spacing: 20) {
                    TextField(LoginField.email.description, text: $viewModel.email)
                        .textContentType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .customStyle()
                        .validation(viewModel.validations.valueOf(LoginField.email.description))
                    
                    VStack {
                        SecureField(LoginField.password.description, text: $viewModel.password)
                            .textContentType(.password)
                            .customStyle()
                            .validation(viewModel.validations.valueOf(LoginField.password.description))

                        HStack {
                            Spacer()

                            Text(Strings.forgotPassword)
                                .font(.footnote)
                                .bold()
                                .foregroundColor(.blue)
                                .padding(.horizontal, 10)
                        }
                    }
                }
                .padding(.bottom, 40)
                
                // Login button
                CustomButton(action: viewModel.login, showLoading: viewModel.isLoading, type: .primaryGradient) {
                    Text(Strings.loginButton)
                }
                
                Spacer()
                
                VStack {
                    Divider()
                    
                    HStack {
                        Text(Strings.signupMessage)
                        NavigationLink(Strings.signupMessageCreate, destination: SignupView())
                            .foregroundColor(.blue)
                    }
                    .padding(.vertical, 10)
                    .font(.footnote)
                }
            }
            .padding(.top, 60)
            .padding([.horizontal, .bottom])
            .errorAlert(visible: $viewModel.showError, message: viewModel.errorMessage, buttonText: Strings.close)
            .navigationBarHidden(true)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .preferredColorScheme(.light)
    }
}
