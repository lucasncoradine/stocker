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
        List(viewModel.shoppingItems) { shoppingItem in
            Button {
                viewModel.checkItem(shoppingItem.id, checked: !shoppingItem.checked)
            } label: {
                CheckmarkLabel(label: shoppingItem.name, checked: shoppingItem.checked)
            }
            .swipeActions {
                Button(role: .destructive, action: { viewModel.remove(id: shoppingItem.id) }) {
                    Label("Remover", systemImage: "cart.badge.minus")
                }
            }
        }
        .showEmptyView(viewModel.shoppingItems.isEmpty, emptyText: "Lista de compras vazia")
        .showLoading(viewModel.isLoading)
        .errorAlert(visible: $viewModel.showError,
                    message: viewModel.errorMessage,
                    action: viewModel.reload)
        .alert("Tem certeza que deseja limpar a lista de compras?", isPresented: $viewModel.showClearConfirmation, actions: {
            Button(role: .cancel , action: {}) {
                Text("Cancelar")
            }
            
            Button(role: .destructive, action: viewModel.clearList) {
                Text("Limpar")
            }
        })
        .navigationTitle("Compras")
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Button(action: { viewModel.showClearConfirmation.toggle() }) {
                    Image(systemName: "trash")
                    Text("Limpar lista")
                }
                
                Spacer()
            }
        }
        .onAppear(perform: viewModel.fetchItems )
    }
}

struct ShoppingListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ShoppingListView(listId: "2LZDjGzpFkwqe4TOcSyC")
        }
    }
}
