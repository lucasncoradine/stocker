//
//  BindingExtension.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 26/05/22.
//

import Foundation
import SwiftUI

extension Array {
    mutating func removeWithDelay(atOffsets: IndexSet, delay: CGFloat = 0.5) {
        var list = self
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            list.remove(atOffsets: atOffsets)
        }
        
        self = list
    }
}
