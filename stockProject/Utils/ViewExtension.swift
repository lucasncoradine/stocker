//
//  ViewExtension.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 26/05/22.
//

import SwiftUI

extension View {
    @ViewBuilder func isHidden(_ hidden: Bool) -> some View {
        if hidden {
            self.hidden()
        }
        
        self
    }
}
