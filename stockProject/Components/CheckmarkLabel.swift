//
//  CheckmarkLabel.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 09/07/22.
//

import SwiftUI

struct CheckmarkLabel<Content: View>: View {
    let checked: Bool
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        HStack(spacing: 10) {
            Checkmark(selected: checked)
            content()
        }
    }
}

extension CheckmarkLabel where Content == Text {
    init(label: String, checked: Bool) {
        self.checked = checked
        self.content = {
            Text(label)
                .foregroundColor(checked ? .gray : Color(.label))
                .striketrough(checked)
        }
    }
}

struct CheckmarkLabel_Previews: PreviewProvider {
    static var previews: some View {
        CheckmarkLabel(label: "Checkmark Label", checked: false)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
