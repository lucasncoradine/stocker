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
        VStack(spacing: 14) {
            if viewModel.currentStep == viewModel.steps.count {
                ProgressView(value: Float(viewModel.currentStep), total: Float(viewModel.steps.count))
                    .progressViewStyle(.linear)
            }
            
            // Fields
            ZStack {
                VStack(spacing: 14) {
                    // Step 0
                    if viewModel.currentStep == 0 {
                        TextField(SignupField.name.description, text: $viewModel.name)
                            .textContentType(.name)
                            .autocapitalization(.words)
                            .customStyle()
                            .validation(viewModel.validations.valueOf(SignupField.name.description))
                        
                        TextField(SignupField.email.description, text: $viewModel.email)
                            .emailField()
                            .customStyle()
                            .validation(viewModel.validations.valueOf(SignupField.email.description))
                    }
                    
                    // Step 1
                    if viewModel.currentStep == 1 {
                        SecureField(SignupField.password.description, text: $viewModel.password)
                            .textContentType(.newPassword)
                            .customStyle()
                            .validation(viewModel.validations.valueOf(SignupField.password.description))
                        
                        SecureField(SignupField.confirmPassword.description, text: $viewModel.confirmPassword)
                            .textContentType(.newPassword)
                            .customStyle()
                            .validation(viewModel.validations.valueOf(SignupField.confirmPassword.description))
                    }
                    
                    // Step 2
                    if viewModel.currentStep == 2 {
                        VStack(alignment: .center, spacing: 20) {
                            Text("🥳").font(.system(size: 72))
                            
                            Text(Strings.signupWelcome)
                                .font(.title)
                                .bold()
                            
                            Text(Strings.signupSuccessMessage)
                                .multilineTextAlignment(.center)
                        }
                    }
                }
            }
            .onChange(of: viewModel.currentStep, perform: viewModel.changeTitle)
            .padding(.vertical)
            
            Divider()
            // Signup Button
            if viewModel.currentStep == viewModel.steps.count {
                CustomButton(action: viewModel.completeSignup, type: .primaryGradient) {
                    Text(Strings.signupAccessButton)
                }
            } else {
                CustomButton(action: viewModel.nextStep, showLoading: viewModel.isLoading, type: .primaryGradient) {
                    Text(viewModel.buttonTitle)
                }
            }
            
            if viewModel.currentStep > 0, viewModel.currentStep < viewModel.steps.count {
                Button(action: viewModel.previousStep) {
                    Text(Strings.back)
                }
            }
            
            Spacer()
        }
        .padding()
        .errorAlert(visible: $viewModel.showError, message: viewModel.errorMessage)
        .onDisappear {
            viewModel.auth.isSigninUp = false
        }
        .navigationTitle(viewModel.navigationTitle)
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SignupView()
        }
    }
}
