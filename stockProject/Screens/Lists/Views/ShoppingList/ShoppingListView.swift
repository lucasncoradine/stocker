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
    @FocusState var editFieldFocused: String?
    @FocusState var counterFocused: Bool
    
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
                ForEach(Array(viewModel.shoppingItems.enumerated()), id: \.offset) { index, shoppingItem in
                    HStack {
                        if viewModel.editingItem == shoppingItem.id {
                            CheckmarkLabel(checked: shoppingItem.checked) {
                                TextField("", text: $viewModel.shoppingItems[index].name)
                                    .focused($editFieldFocused, equals: shoppingItem.id)
                                    .submitLabel(.done)
                                    .onSubmit {
                                        viewModel.save(id: shoppingItem.id)
                                    }
                            }
                        } else {
                            CheckmarkLabel(label: shoppingItem.name, checked: shoppingItem.checked)
                                .onTapGesture {
                                    viewModel.checkItem(shoppingItem.id, checked: !shoppingItem.checked)
                                }
                        }
                        
                        Stepper(label: "",
                                amount: shoppingItem.amount,
                                counterFocused: _counterFocused
                        ) { value in
                            viewModel.changeAmount(id: shoppingItem.id, newValue: value)
                        }
                    }
                    .buttonStyle(.plain)
                    .swipeActions {
                        Button(role: .destructive, action: { viewModel.remove(id: shoppingItem.id) }) {
                            Label(Strings.remove, systemImage: "cart.badge.minus")
                        }
                    }
                    .contextMenu {
                        Button(action: { viewModel.editingItem = shoppingItem.id }) {
                            Label(Strings.rename, systemImage: "pencil")
                        }
                    }
                }
                
                // New Item
                if viewModel.creatingNewItem {
                    CheckmarkLabel(checked: false) {
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
                    Button(action: { viewModel.toggleNewItem() }) {
                        Label(Strings.new, systemImage: "plus")
                    }
                    
                    Menu {
                        // TODO: Complete list
//                        Button(action: {}) {
//                            Label(Strings.shoppingListComplete, systemImage: "checkmark.circle")
//                        }
                        
                        Button(action: { viewModel.showClearConfirmation.toggle() }) {
                            Label(Strings.shoppingListClear, systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            
            // Keyboard Toolbar
            ToolbarItemGroup(placement: .keyboard) {
                HStack {
                    Spacer()
                    
                    Button(action: viewModel.dismissKeyboard) {
                        Text(Strings.cancel)
                    }
                }
            }
        }
        .onChange(of: viewModel.creatingNewItem) { isCreating in
            self.itemFieldFocused = isCreating
        }
        .onChange(of: viewModel.editingItem) { editingId in
            self.editFieldFocused = editingId
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
