//
//  HomeTableRow.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 13/05/22.
//

import SwiftUI

struct HomeTableRow: View {
    let label: String
    let isStock: Bool
    
    init(label: String, isStock: Bool) {
        self.label = label
        self.isStock = isStock
    }
    
    var body: some View {
        HStack(spacing: 10) {
            Text(label)
            
            if isStock {
                Image(systemName: "shippingbox.circle.fill")
                    .foregroundColor(.green)
            }
        }
    }
}

struct HomeTableRow_Previews: PreviewProvider {
    static var previews: some View {
        HomeTableRow(label: "Row preview", isStock: true)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
