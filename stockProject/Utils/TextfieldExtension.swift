//
//  TextfieldExtension.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 05/07/22.
//

import Foundation
import SwiftUI

extension View {
    @ViewBuilder func fieldError(_ condition: Bool, message: String) -> some View {
        VStack(alignment: .leading) {
            self
            
            if condition {
                Text(message)
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
    }
}
