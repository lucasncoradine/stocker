//
//  BindingExtension.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 26/07/22.
//

import SwiftUI

extension Binding where Value == Bool {
    var not: Binding<Bool> {
        return !self
    }
}

