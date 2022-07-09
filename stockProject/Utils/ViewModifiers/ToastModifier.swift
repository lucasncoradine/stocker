//
//  ToastModifier.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 07/07/22.
//

import Foundation
import SwiftUI

enum ToastShape {
    case rounded
    case capsule
    
    var cornerRadius: CGFloat {
        switch self {
        case .capsule:
            return 100
        case .rounded:
            return 13
        }
    }
}

struct ToastModifier: ViewModifier {
    @Binding var isShowing: Bool
    let message: String
    let duration: TimeInterval = 3
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isShowing {
                VStack {
                    Spacer()
                    
                    Text(message)
                        .font(.footnote)
                        .padding()
                        .background(.ultraThinMaterial, in: Capsule())
                }
                .onAppear {
                    doAfter(duration) {
                        isShowing = false
                    }
                }
                .onTapGesture {
                    isShowing = false
                }
            }
        }
        .animation(.easeOut, value: isShowing)
    }
}
