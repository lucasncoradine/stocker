//
//  TableRow.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 27/04/22.
//

import SwiftUI

struct TableRow: View {
    let label: String
    let isStock: Bool
    
    init(label: String, isStock: Bool = false) {
        self.label = label
        self.isStock = isStock
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(self.label)
                
                if(self.isStock) {
                    Image(systemName: "shippingbox.circle.fill")
                        .foregroundColor(.green)
                }
                
                Spacer()
            }
            .padding(.horizontal)
        }
    }
}

struct TableRow_Previews: PreviewProvider {
    static var previews: some View {
        TableRow(label: "Linha da exemplo", isStock: true)
            .previewLayout(.sizeThatFits)
            .padding(.vertical)
    }
}
