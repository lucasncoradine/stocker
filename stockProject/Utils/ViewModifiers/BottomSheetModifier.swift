//
//  BottomSheetModifier.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 21/07/22.
//

import SwiftUI

struct BottomSheet<Content: View>: View {
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        VStack {
            content()
        }
        .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height * 0.5)
    }
}

struct BottomSheetModifier: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            content
            
            VStack {
                Spacer()
                
                VStack {
                    
                }
            }
            .background(.black.opacity(0.5))
        }
    }
}
