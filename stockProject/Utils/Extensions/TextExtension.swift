//
//  TextExtension.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 09/07/22.
//

import Foundation
import SwiftUI

extension Text {
    @ViewBuilder func striketrough(_ condition: Bool) -> Self {
        condition ? self.strikethrough() : self
    }
}
