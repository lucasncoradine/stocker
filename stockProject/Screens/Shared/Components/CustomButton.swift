//
//  CustomTextfield.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 12/07/22.
//

import SwiftUI

struct CustomButton<Content: View>: View {
    private let action: () -> Void
    private let content: () -> Content
    private let showLoading: Bool
    
    init(action: @escaping () -> Void,
         showLoading: Bool = false,
         @ViewBuilder content: @escaping () -> Content
    ) {
        self.action = action
        self.content = content
        self.showLoading = showLoading
    }
    
    var body: some View {
        Button(action: self.action) {
            HStack {
                if showLoading {
                    ProgressView().tint(.white)
                } else {
                    self.content()
                }
            }
            .frame(maxWidth: .infinity, minHeight: 20)
            .font(.system(size: 16, weight: .bold))
            .padding()
            .foregroundColor(.white)
            .background(
                RoundedRectangle(cornerRadius: 13)
                    .fill(.blue)
                    .opacity(showLoading ? 0.5: 1)
            )
        }
        .disabled(showLoading)
    }
}

struct CustomTextfield_Previews: PreviewProvider {
    static var previews: some View {
        CustomButton(action: {}) {
            Text("Custom button")
        }
        .padding()
    }
}
