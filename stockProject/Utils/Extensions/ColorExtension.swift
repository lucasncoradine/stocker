//
//  ColorExtension.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 17/07/22.
//

import SwiftUI

extension Color {
    static let accentGreen = Color("AccentGreen")
    static let accentBlue = Color("AccentBlue")
}

extension LinearGradient {
    static let primaryGradient = LinearGradient(gradient: Gradient(colors: [.accentBlue, .accentGreen]),
                                                startPoint: .leading,
                                                endPoint: .trailing)
    
    static let primaryGradientVertical = LinearGradient(gradient: Gradient(colors: [.accentBlue, .accentGreen]),
                                                startPoint: .top,
                                                endPoint: .bottom)
}
