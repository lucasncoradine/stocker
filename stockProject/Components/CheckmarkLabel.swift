//
//  CheckmarkLabel.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 09/07/22.
//

import SwiftUI

struct CheckmarkLabel: View {
    let label: String
    let checked: Bool
    
    var body: some View {
        HStack {
            Checkmark(selected: checked)
            
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
