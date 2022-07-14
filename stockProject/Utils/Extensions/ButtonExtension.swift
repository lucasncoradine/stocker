//
//  ButtonExtension.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 12/07/22.
//

import Foundation
import SwiftUI

extension Button {
    @ViewBuilder func customStyle() -> some View {
        self
            .frame(maxWidth: .infinity, maxHeight: 20)
            .padding()
            .font(.system(size: 16, weight: .bold))
            .background(.blue)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 13))
    }
}
