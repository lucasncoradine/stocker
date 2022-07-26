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
                    Label(Strings.remove, systemImage: "cart.badge.minus")
                }
            }
        }
        .listStyle(.plain)
        .showEmptyView(viewModel.shoppingItems.isEmpty, emptyText: Strings.shoppingListEmpty)
        .showLoading(viewModel.isLoading)
        .errorAlert(visible: $viewModel.showError,
                    message: viewModel.errorMessage,
                    action: viewModel.reload)
        .alert(Strings.shoppingListConfirmClearMessage, isPresented: $viewModel.showClearConfirmation, actions: {
            Button(role: .cancel , action: {}) {
                Text(Strings.cancel)
            }
            
            Button(role: .destructive, action: viewModel.clearList) {
                Text(Strings.shoppingListConfirmClearButton)
            }
        })
        .navigationTitle(Strings.shoppingListTitle)
        .toolbar {
            ToolbarItemGroup() {
                Button(action: { viewModel.showClearConfirmation.toggle() }) {
                    Label(Strings.shoppingListClear, systemImage: "trash")
                }
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
