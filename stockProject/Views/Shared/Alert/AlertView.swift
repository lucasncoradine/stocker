//
//  Alert.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 24/05/22.
//

import SwiftUI

extension View {
    func errorAlert(message: String,
                    visible: Binding<Bool>,
                    action: @escaping () -> Void,
                    buttonText: String = "Try again"
    ) -> some View {
        return self.alert(message, isPresented: visible) {
            Button(action: action) {
                Text(buttonText)
            }
        }
    }
}
