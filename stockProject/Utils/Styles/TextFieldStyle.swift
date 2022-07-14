//
//  TextFieldStyle.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 12/07/22.
//

import Foundation
import SwiftUI

struct CustomTextField: TextFieldStyle {
    func _Body(configuration: TextField<Self._Label>) -> some View {
           configuration
               .padding(10)
               .background(LinearGradient(gradient: Gradient(colors: [Color.orange, Color.orange]), startPoint: .topLeading, endPoint: .bottomTrailing))
               .cornerRadius(20)
               .shadow(color: .gray, radius: 10)
       }
}
