//
//  ListItemsView.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 01/07/22.
//

import SwiftUI

struct ListItemsView: View {
    private let navigationTitle: String
    @StateObject var viewModel: ListItemsViewModel
    
    // MARK: Lifecycle
    init(listId: String, listName: String) {
        self._viewModel = StateObject(wrappedValue: .init(listId: listId))
        self.navigationTitle = listName
    }
    
    var body: some View {
        VStack {
            if viewModel.items.isEmpty {
                EmptyView(text: "No items")
            } else {
                List {
                    Section {
                        NavigationLink(destination: {}) {
                            Text("Lista de compras")
                        }
                    }
                    
                    Section {
                        ForEach(viewModel.items) { item in
                            Stepper(label: item.name, amount: item.amount)
                                .buttonStyle(.plain)
                        }
                    }
                }
            }
        }
        .showLoading(viewModel.isLoading)
        .navigationTitle(navigationTitle)
        .onAppear(perform: viewModel.fetchItems)
    }
}

struct ListItemsView_Previews: PreviewProvider {
    static var previews: some View {
        ListItemsView(listId: "Zxs0zOEwrxJE709jEEPI", listName: "Estoque")
    }
}
