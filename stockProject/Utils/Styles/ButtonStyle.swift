//
//  ButtonStyle.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 12/07/22.
//

import Foundation
import SwiftUI

struct CustomButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(.blue)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 13))
            .font(.system(size: 16, weight: .bold))
    }
}
