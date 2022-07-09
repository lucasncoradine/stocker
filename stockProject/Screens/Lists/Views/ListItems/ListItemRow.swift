//
//  ListItemRow.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 07/07/22.
//

import SwiftUI

struct ListItemRow: View {
    let item: ItemModel
    
    var body: some View {
        Stepper(label: item.name,
                amount: item.amount,
                description: item.description,
                counterFocused: _counterFocused
        ) { value in
            viewModel.changeAmount(itemId: item.id, newValue: value)
        }
        .buttonStyle(.plain)
    }
}

struct ListItemRow_Previews: PreviewProvider {
    static var previews: some View {
        ListItemRow()
    }
}
