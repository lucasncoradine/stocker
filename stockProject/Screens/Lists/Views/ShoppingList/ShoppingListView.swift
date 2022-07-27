//
//  ShoppingListView.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 06/07/22.
//

import SwiftUI

struct ShoppingListView: View {
    @StateObject var viewModel: ShoppingListViewModel
    @FocusState var itemFieldFocused: Bool
    
    // MARK: - Lifecycle
    init(listId: String) {
        self._viewModel = StateObject(wrappedValue: ShoppingListViewModel(listId: listId))
    }
    
    var showEmptyListView: Bool {
        viewModel.shoppingItems.isEmpty && viewModel.creatingNewItem == false
    }
    
    var body: some View {
        List {
            Section {
                ForEach(viewModel.shoppingItems) { shoppingItem in
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
                
                // New Item
                if viewModel.creatingNewItem {
                    HStack {
                        Checkmark(selected: false)
                        
                        TextField(Strings.listItemsNew, text: $viewModel.newItemName)
                            .focused($itemFieldFocused)
                            .submitLabel(.done)
                            .onSubmit(viewModel.create)
                    }
                }
            }
        }
        .listStyle(.plain)
        .showEmptyView(showEmptyListView, emptyText: Strings.shoppingListEmpty)
        .showLoading(viewModel.isLoading)
        .errorAlert(visible: $viewModel.showError,
                    message: viewModel.errorMessage,
                    action: viewModel.reload)
        .alert(Strings.shoppingListConfirmClearMessage, isPresented: $viewModel.showClearConfirmation) {
            Button(role: .cancel , action: {}) {
                Text(Strings.cancel)
            }
            
            Button(role: .destructive, action: viewModel.clearList) {
                Text(Strings.shoppingListConfirmClearButton)
            }
        }
        .navigationTitle(Strings.shoppingListTitle)
        .toolbar {
            // Main Toolbar
            ToolbarItemGroup() {
                HStack {
                    Button(action: viewModel.toggleNewItem) {
                        Label(Strings.new, systemImage: "plus")
                    }
                    
                    Button(action: { viewModel.showClearConfirmation.toggle() }) {
                        Label(Strings.shoppingListClear, systemImage: "trash")
                    }
                }
            }
            
            // Keyboard Toolbar
            ToolbarItemGroup(placement: .keyboard) {
                HStack {
                    Spacer()
                    
                    Button(action: viewModel.toggleNewItem) {
                        Text(Strings.cancel)
                    }
                }
            }
        }
        .onChange(of: viewModel.creatingNewItem, perform: { isCreating in
            self.itemFieldFocused = isCreating
        })
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
