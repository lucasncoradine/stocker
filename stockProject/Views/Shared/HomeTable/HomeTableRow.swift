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
    
    var backgroundColor: UIColor {
        isStock ? .systemGreen : .systemBlue
    }
    
    var listImage: String {
        isStock ? "archivebox" : "list.bullet"
    }
    
    // MARK: - Lifecycle
    init(label: String, isStock: Bool) {
        self.label = label
        self.isStock = isStock
    }
    
    // MARK: - Views
    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle().frame(width: 28, height: 28)
                    .foregroundColor(Color(uiColor: backgroundColor))
                
                Image(systemName: listImage)
                    .foregroundColor(.white)
                    .font(.system(size: 14, weight: .bold))
            }
            
            Text(label)
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
