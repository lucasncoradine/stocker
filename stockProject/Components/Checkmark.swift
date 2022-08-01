//
//  Checkmark.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 09/07/22.
//

import SwiftUI

struct Checkmark: View {
    let selected: Bool
    
    var body: some View {
        Image(systemName: selected ? "checkmark.circle.fill" : "circle")
            .resizable()
            .scaledToFit()
            .frame(height: 22)
            .foregroundColor(selected ? .blue : Color(.systemGray3))
    }
}

struct Checkmark_Previews: PreviewProvider {
    static var previews: some View {
        Checkmark(selected: false)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
