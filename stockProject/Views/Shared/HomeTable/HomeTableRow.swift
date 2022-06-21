//
//  HomeTableRow.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 13/05/22.
//

import SwiftUI

struct HomeTableRow: View {
    let label: String
    let type: ListType
    
    // MARK: - Views
    var body: some View {
        HStack(spacing: 16) {
            ListImage(listType: type, size: 28)
            Text(label)
        }
    }
}

struct HomeTableRow_Previews: PreviewProvider {
    static var previews: some View {
        HomeTableRow(label: "Row preview", type: .simple)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
