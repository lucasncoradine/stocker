//
//  ShoppingListView.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 06/07/22.
//

import SwiftUI

struct ShoppingListView: View {
    @StateObject var viewModel: ShoppingListViewModel
    
    // MARK: - Lifecycle
    init(listId: String) {
        self._viewModel = StateObject(wrappedValue: ShoppingListViewModel(listId: listId))
    }
    
    var body: some View {
        List(viewModel.items) { item in
            Text(item.name)
                .swipeActions {
                    Button(role: .destructive, action: { viewModel.remove(id: item.id) } ) {
                        Label("Remover", systemImage: "cart.badge.minus")
                    }
                }
        }
        .navigationTitle("Compras")
        .onAppear(perform: viewModel.fetchItems )
    }
}

struct ShoppingListView_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingListView(listId: "")
    }
}
