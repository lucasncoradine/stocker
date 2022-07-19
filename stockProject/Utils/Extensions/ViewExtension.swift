//
//  ViewExtension.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 01/07/22.
//

import SwiftUI

extension View {
    /// Shows a ProgressView if the condition is satisfied
    @ViewBuilder func showLoading(_ condition: Bool, inline: Bool = false) -> some View {
        if condition {
            HStack(spacing: 5) {
                if inline {
                    self.opacity(0.5)
                }
                
                ProgressView()
            }
        } else {
            self
        }
    }
    
    /// Shows an error alert
    func errorAlert(visible: Binding<Bool>,
                    message: String,
                    action: @escaping () -> Void = {},
                    buttonText: String = "Tentar novamente"
    ) -> some View {
        return self.alert(message, isPresented: visible) {
            Button(action: action) {
                Text(buttonText)
            }
        }
    }
    
    /// Shows a toast with a custom message
    func toast(isShowing: Binding<Bool>, message: String) -> some View {
        self.modifier(ToastModifier(isShowing: isShowing, message: message))
    }
    
    /// Show the empty view if the condition is satisfied
    @ViewBuilder func showEmptyView(_ condition: Bool, emptyText: String) -> some View {
        if condition {
            EmptyView(text: emptyText)
        } else {
            self
        }
    }
    
    /// Set the opacity of  the view to `0` if the condition is satisfied
    @ViewBuilder func visible(_ condition: Bool) -> some View {
        self.opacity(condition ? 1 : 0)
    }
}
