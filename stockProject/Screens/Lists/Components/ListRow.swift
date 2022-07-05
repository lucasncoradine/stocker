//
//  ListRow.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 01/07/22.
//

import SwiftUI

struct ListRow: View {
    let label: String
    
    var body: some View {
        HStack(spacing: 10) {
            ListIcon(size: 24)
            Text(label)
        }
    }
}

struct ListRow_Previews: PreviewProvider {
    static var previews: some View {
        ListRow(label: "List name")
    }
}
