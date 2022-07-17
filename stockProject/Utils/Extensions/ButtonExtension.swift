//
//  ButtonExtension.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 12/07/22.
//

import Foundation
import SwiftUI

extension Button {
    @ViewBuilder func fullwidth() -> some View {
        self.frame(maxWidth: .infinity)
    }
}
