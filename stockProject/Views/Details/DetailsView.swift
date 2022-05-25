//
//  DetailsView.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 23/05/22.
//

import SwiftUI

struct DetailsView: View {
    let list: ListModel
    
    // MARK: - View
    var body: some View {
        VStack {
            TabView {
                // Details List
                DetailsListView(list: list)
                    .tabItem {
                        Image(systemName: "shippingbox")
                        Text("Estoque")
                    }
                    .tag(0)
                
                // Details Shopping List
                Text("Shopping List View") //TODO: ShoppingListView
                    .tabItem {
                        Image(systemName: "cart")
                        Text("Lista de Compras")
                    }
                    .tag(1)
            }
        }
    }
}

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsView(list: .init(name: "Sample list",
                               type: .stock,
                               items: [
                                .init(id: UUID(), name: "Sample Item", amount: 3)
                               ]))
    }
}
