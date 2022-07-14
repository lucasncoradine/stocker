//
//  SignupView.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 12/07/22.
//

import SwiftUI

struct SignupView: View {
    var body: some View {
        VStack {
            // Fields
            VStack(spacing: 20) {
                TextField("Nome", text: .constant(""))
                    .textContentType(.name)
                    .customStyle()
                
                TextField("Email", text: .constant(""))
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .customStyle()
                
                SecureField("Senha", text: .constant(""))
                    .textContentType(.newPassword)
                    .customStyle()
                
                SecureField("Confirmar senha", text: .constant(""))
                    .textContentType(.newPassword)
                    .customStyle()
            }
            
            // Signup Button
            Button(action: {}) {
                Text("Criar conta")
            }
            .customStyle()
            .padding(.top, 30)
            
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
