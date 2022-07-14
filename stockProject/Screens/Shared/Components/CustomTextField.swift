//
//  CustomTextfield.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 12/07/22.
//

import SwiftUI

enum CustomTextFieldType {
    case plain
    case secure
}

// MARK: - Field
private struct Field: View {
    let type: CustomTextFieldType
    let placeholder: String
    let value: Binding<String>
    
    var body: some View {
        if type == .secure {
            SecureField(placeholder, text: value)
        } else {
            TextField(placeholder, text: value)
        }
    }
}

// MARK: - CustomTextField
struct CustomTextField: View {
    private let placeholder: String
    private let value: Binding<String>
    private let alignment: TextAlignment
    private let type: CustomTextFieldType
    
    init(placeholder: String = "",
         value: Binding<String>,
         alignment: TextAlignment = .leading,
         type: CustomTextFieldType = .plain
    ) {
        self.placeholder = placeholder
        self.value = value
        self.alignment = alignment
        self.type = type
    }
    
    var body: some View {
        Field(type: type, placeholder: placeholder, value: value)
            .padding(.horizontal , 15)
            .frame(height: 39.0)
            .background(Color(.systemFill))
            .cornerRadius(13)
            .multilineTextAlignment(alignment)
        
    }
}

struct CustomTextfield_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextField(placeholder: "Textfield", value: .constant(""))
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
