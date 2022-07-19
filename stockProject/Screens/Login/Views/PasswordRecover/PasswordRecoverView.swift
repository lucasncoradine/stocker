//
//  PasswordRecoverView.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 19/07/22.
//

import SwiftUI

struct PasswordRecoverView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: PasswordRecoverViewModel
    
    init(with email: String = "") {
        self._viewModel = StateObject(wrappedValue: .init(with: email))
    }
    
    var body: some View {
        VStack(spacing: 30) {
            if !viewModel.emailSent {
                VStack {
                    Text(Strings.passwordRecoverLabel)
                        .font(.title2)
                        .bold()
                        .padding(.bottom, 30)
                    
                    TextField(PasswordRecoverFields.email.description, text: $viewModel.email)
                        .customStyle()
                        .emailField()
                        .validation(viewModel.validations.valueOf(PasswordRecoverFields.email.description))
                }
                
                CustomButton(action: viewModel.sendEmail, showLoading: viewModel.isLoading, type: .primaryGradient) {
                    Text(Strings.passwordRecoverButtonRecover)
                }
            } else {
                Text("📬").font(.system(size: 72))
                Text(Strings.passwordRecoverEmailSent).font(.title).bold()
                Text(Strings.passwordRecoverMessage)
                    .multilineTextAlignment(.center)
                
                CustomButton(action: { dismiss() }, type: .primaryGradient) {
                    Text(Strings.passwordRecoverButtonBack)
                }
            }
        }
        .errorAlert(visible: $viewModel.showError, message: viewModel.errorMessage, buttonText: Strings.close)
        .padding()
    }
}

struct PasswordRecoverView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PasswordRecoverView()
        }
    }
}
