//
//  CustomTextfield.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 12/07/22.
//

import SwiftUI

struct CustomButtonFill: ShapeStyle {
    
}

enum CustomButtonType {
    case normal(color: Color)
    case primaryGradient
    
    var fill: LinearGradient {
        switch self {
        case .primaryGradient:
            return LinearGradient(gradient: Gradient(colors: [.accentBlue, .accentGreen]),
                           startPoint: .leading,
                           endPoint: .trailing)
        case .normal(let color):
            return LinearGradient(gradient: Gradient(colors: [color, color]),
                           startPoint: .leading,
                           endPoint: .trailing)
        }
    }
}

struct CustomButton<Content: View>: View {
    private let action: () -> Void
    private let content: () -> Content
    private let showLoading: Bool
    private let type: CustomButtonType
    
    init(action: @escaping () -> Void,
         showLoading: Bool = false,
         type: CustomButtonType = .normal(color: .blue),
         @ViewBuilder content: @escaping () -> Content
    ) {
        self.action = action
        self.content = content
        self.type = type
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
                    .fill(type.fill)
                    .opacity(showLoading ? 0.5: 1)
            )
        }
        .disabled(showLoading)
    }
}

struct CustomTextfield_Previews: PreviewProvider {
    static var previews: some View {
        CustomButton(action: {}, type: .primaryGradient) {
            Text("Custom button")
        }
        .padding()
    }
}
