//
//  TextfieldExtension.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 05/07/22.
//

import Foundation
import SwiftUI

extension View {
    @ViewBuilder func fieldError(condition: Bool, message: String) -> some View {
        VStack(alignment: .leading) {
            self
            
            if condition {
                Text(message)
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
    }
    
    @ViewBuilder func fieldError(_ message: String) -> some View {
        VStack(alignment: .leading) {
            self
            
            if !message.isEmpty {
                Text(message)
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
    }
    
    @ViewBuilder func customStyle(alignment: TextAlignment = .leading) -> some View {
        self
            .frame(height: 39.0)
            .padding(.horizontal , 15)
            .background(Color(.systemGray5))
            .cornerRadius(13)
            .multilineTextAlignment(alignment)
    }
    
    @ViewBuilder func emailField() -> some View {
        self
            .textContentType(.emailAddress)
            .keyboardType(.emailAddress)
            .textInputAutocapitalization(.never)
    }
    
    @ViewBuilder func validation(_ object: ValidationObject?) -> some View {
        if let object = object, object.isValid == false {
            self.fieldError(object.message)
        } else {
            self
        }
    }
}
