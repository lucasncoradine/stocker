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
                EmptyView(text: "Sem itens")
            } else {
                List {
                    Section {
                        NavigationLink(destination: {}) {
                            Text("Lista de compras")
                        }
                    }
                    
                    Section {
                        ForEach(viewModel.items) { item in
                            Stepper(label: item.name, amount: item.amount, description: item.description)
                            .buttonStyle(.plain)
                            .contextMenu {
                                Button(action: { viewModel.editItem(item) }) {
                                    Label("Editar", systemImage: "square.and.pencil")
                                }

                                Button(role: .destructive, action: { viewModel.deleteItem(id: item.id) }) {
                                    Label("Remover", systemImage: "trash")
                                }
                            }
                            .swipeActions {
                                Button(role: .destructive, action: { viewModel.deleteItem(id: item.id) } ) {
                                    Label("Remover", systemImage: "trash")
                                }
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
        .showLoading(viewModel.isLoading)
        .navigationTitle(navigationTitle)
        .sheet(isPresented: $viewModel.openEdit) {
            EditItemView(listId: viewModel.listId, item: viewModel.selectedItem)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: viewModel.createItem) {
                    Image(systemName: "plus")
                }
            }
        }
        .onAppear(perform: viewModel.fetchItems)
    }
}

struct ListItemsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ListItemsView(listId: "SF6jqiRauIkLSTurDy15", listName: "Estoque")
        }
    }
}
