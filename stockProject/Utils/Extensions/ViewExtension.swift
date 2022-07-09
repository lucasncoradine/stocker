//
//  ViewExtension.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 01/07/22.
//

import SwiftUI

extension View {
    /// Shows a ProgressView if the condition is satisfied
    @ViewBuilder func showLoading(_ condition: Bool) -> some View {
        if condition == true {
            ProgressView()
        } else {
            self
        }
    }
    
    /// Shows an error alert
    func errorAlert(visible: Binding<Bool>,
                    message: String,
                    action: @escaping () -> Void,
                    buttonText: String = "Try again"
    ) -> some View {
        return self.alert(message, isPresented: visible) {
            Button(action: action) {
                Text(buttonText)
            }
        }
    }
    
    func toast(isShowing: Binding<Bool>, message: String) -> some View {
        self.modifier(ToastModifier(isShowing: isShowing, message: message))
    }
}
