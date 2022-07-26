//
//  BottomToolbar.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 16/07/22.
//

import Foundation
import SwiftUI

/// A customized button to use inside the `.bottomToolbar`
/// - Parameters:
///   - action: The closure to execute when the button is tapped.
///   - content: A view builder that creates the content of the button.
struct BottomToolbarItem<Content: View>: View {
    let action: () -> Void
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        Button(action: action) {
            content()
        }
        .fullwidth()
    }
}

extension View {
    /// Creates a custom toolbar at the bottom of the screen
    /// - Parameters:
    ///  - visible: Tells if the toolbar is visible or not.
    ///  - content: A view builder that creates the content of this toolbar.
    ///
    /// **Usage**
    /// ```
    /// VStack {
    ///     Text("Hello...")
    /// }
    /// .bottomToolbar {
    ///     BottomToolbarItem(action: {
    ///         print("... World!")
    ///     }) {
    ///         Text("Click me")
    ///     }
    /// }
    /// ```
    @ViewBuilder func bottomToolbar<Content: View>(visible: Bool,
                                                   @ViewBuilder _ content: @escaping () -> Content
    ) -> some View {
        ZStack {
            self
            
            if visible {
                VStack(spacing: 0) {
                    Spacer()
                    Divider()
                    
                    VStack {
                        content().padding([.top, .horizontal])
                    }
                    .frame(maxWidth: .infinity,
                           maxHeight: 85,
                           alignment: .top)
                    .background(.ultraThinMaterial, in: Rectangle())
                }
                .transition(.move(edge: .bottom))
            }
        }
        .animation(.easeInOut(duration: 0.3), value: visible)
        .edgesIgnoringSafeArea(.bottom)
    }
}
