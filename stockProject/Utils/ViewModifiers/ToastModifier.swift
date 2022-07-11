//
//  ToastModifier.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 07/07/22.
//

import Foundation
import SwiftUI

struct ToastModifier: ViewModifier {
    @Binding var isShowing: Bool
    let message: String
    let duration: TimeInterval = 3
    
    @State private var work: DispatchWorkItem? = nil
    
    private func createWork() -> DispatchWorkItem {
        work?.cancel()
        
        let newWork = DispatchWorkItem {
            self.isShowing = false
        }
        
        work = newWork
        
        return newWork
    }
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            VStack {
                Spacer()
                
                Text(message)
                    .font(.footnote)
                    .padding()
                    .background(.ultraThinMaterial, in: Capsule())
            }
            .onChange(of: isShowing, perform: { show in
                if show {
                    let work = createWork()
                    doAfter(duration, work: work)
                }
            })
            .onTapGesture {
                isShowing = false
            }
            .visible(isShowing)
        }
        .animation(.easeOut, value: isShowing)
    }
}
