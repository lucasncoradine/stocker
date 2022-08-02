//
//  ListItemsView.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 01/07/22.
//

import SwiftUI

struct ListItemsView: View {
    private let listName: String
    
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: ListItemsViewModel
    @FocusState var counterFocused: Bool
    
    // MARK: - Lifecycle
    init(list: ListModel) {
        self._viewModel = StateObject(wrappedValue: .init(list: list))
        self.listName = list.name
    }
    
    // MARK: - Private variables and functions
    private func navigationTitle() -> String {
        let selectedCount: Int = viewModel.selection.count
        
        if selectedCount == 0 {
            return listName
        } else {
            let selectedWord: String = selectedCount > 1 ? Strings.selectedItemsTextPlural : Strings.selectedItemsText
            return "\(selectedCount) \(selectedWord)"
        }
    }
    
    private func validateItem(isExpired: Bool, needToBuy: Bool) -> ItemAlertType {
        if isExpired {
            return .expired
        }
        
        if needToBuy {
            return .needToBuy
        }
        
        return .none
    }
    
    // MARK: - View
    var body: some View {
        VStack {
            List {
                Section {
                    NavigationLink(destination: ShoppingListView(listId: viewModel.listId)) {
                        HStack {
                            Image(systemName: "cart")
                            Text(Strings.shoppingList)
                        }
                    }
                    .disabled(viewModel.isEditing)
                }
                
                Section {
                    ForEach(viewModel.items, id: \.id) { item in
                        HStack {
                            // MARK: Checkmark icon
                            if viewModel.isEditing {
                                Checkmark(selected: viewModel.selection.contains(item.id))
                            }
                            
                            if item.alertType != .none {
                                Image(systemName: item.alertType.icon)
                                    .foregroundColor(item.alertType.color)
                            }
                            
                            Stepper(label: item.name,
                                    amount: item.amount,
                                    description: item.description,
                                    counterFocused: _counterFocused
                            ) { value in
                                viewModel.changeAmount(itemId: item.id, itemName: item.name, newValue: value)
                            }
                            .buttonStyle(.plain)
                            .foregroundColor(item.alertType.color)
                            .disabled(viewModel.isEditing)
                        }
                        .contextMenu {
                            Button(action: { viewModel.addToShoppingList(itemId: item.id, itemName: item.name) }) {
                                Label(Strings.addToShopping, systemImage: "cart.badge.plus")
                            }
                            
                            Button(action: { viewModel.editItem(id: item.id) }) {
                                Label(Strings.edit, systemImage: "square.and.pencil")
                            }
                            
                            Button(role: .destructive, action: { viewModel.deleteItem(id: item.id) }) {
                                Label(Strings.remove, systemImage: "trash")
                            }
                        }
                        // MARK: - Right Swipe
                        .swipeActions {
                            Button(role: .destructive, action: { viewModel.deleteItem(id: item.id) } ) {
                                Label(Strings.remove, systemImage: "trash")
                            }
                        }
                        
                        // MARK: - Left Swipe
                        .swipeActions(edge: .leading) {
                            Button(action: { viewModel.addToShoppingList(itemId: item.id, itemName: item.name) }) {
                                Label(Strings.addToShopping, systemImage: "cart.badge.plus")
                            }
                            .tint(.blue)
                        }
                        .onTapGesture {
                            if viewModel.isEditing {
                                viewModel.selection.toggle(item.id)
                            }
                        }
                    }
                } header: {
                    Text(viewModel.items.isEmpty ? Strings.listItemsEmpty : Strings.items)
                }
            }
            .alert(Strings.listItemsRemoveSelectedMessage, isPresented: $viewModel.showDeleteConfirmation, actions: {
                Button(role: .cancel , action: {}) {
                    Text(Strings.cancel)
                }
                
                Button(role: .destructive, action: { viewModel.deleteSelectedItems() }) {
                    Text(Strings.remove)
                        .bold()
                        .tint(.red)
                }
            })
            .animation(.linear, value: viewModel.items)
            .listStyle(.insetGrouped)
            .onChange(of: viewModel.isEditing) { value in
                if value == false {
                    viewModel.selection.removeAll()
                }
            }
        }
        .bottomToolbar(visible: viewModel.showBottomToolbar) {
            HStack {
                // Add to shopping list
                BottomToolbarItem(action: viewModel.addSelectedToShoppingList) {
                    Label(Strings.addToShopping, systemImage: "cart.badge.plus")
                }
                .disabled(viewModel.selection.isEmpty)
                
                // Remove from list
                BottomToolbarItem(action: { viewModel.showDeleteConfirmation.toggle() }) {
                    Label(Strings.remove, systemImage: "trash")
                }
                .disabled(viewModel.selection.isEmpty)
            }
        }
        .showLoading(viewModel.isLoading)
        .toast(isShowing: $viewModel.showAddedToast, message: Strings.listItemsAddedToast)
        .navigationTitle(navigationTitle())
        .navigationBarBackButtonHidden(viewModel.isEditing)
        .toolbar {
            // MARK: - Main Toolbar
            ToolbarItemGroup() {
                if !viewModel.isEditing {
                    HStack {
                        // Create Item
                        Button(action: viewModel.createItem) {
                            Label(Strings.editItemNavigationTitle, systemImage: "plus")
                        }
                        
                        // "More Options" menu
                        Menu {
                            // Select items
                            Button(action: viewModel.toggleSelection) {
                                Label(Strings.select, systemImage: "checkmark.circle")
                            }
                            
                            // Edit list
                            Button(action: { viewModel.showEditList.toggle() }) {
                                Label(Strings.edit, systemImage: "square.and.pencil")
                            }
                            
                            // Share list
                            Button(action: { viewModel.openShare.toggle() }) {
                                Label(Strings.share, systemImage: "person.crop.circle.badge.plus")
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                        }
                    }
                }
            }
            
            // MARK: - Editing Toolbar
            ToolbarItemGroup(placement: .navigationBarLeading) {
                if viewModel.isEditing {
                    Button(action: viewModel.toggleAll) {
                        Text(Strings.selectAll)
                    }
                }
            }
            
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                if viewModel.isEditing {
                    Button(action: viewModel.toggleSelection) {
                        Text(Strings.ok)
                            .bold()
                    }
                }
            }
            
            // MARK: - Keyboard Toolbar
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                
                Button(Strings.done) {
                    UIApplication.shared.dismissKeyboard()
                }
                .foregroundColor(.blue)
            }
        }
        // Edit list
        .sheet(isPresented: $viewModel.showEditList) {
            EditListView(list: viewModel.list)
        }
        // Edit item
        .sheet(isPresented: $viewModel.openEdit) {
            EditItemView(listId: viewModel.listId, item: viewModel.selectedItem) { item in
                viewModel.handleEditedItem(item)
            }
        }
        // Share list
        .sheet(isPresented: $viewModel.openShare) {
            ShareListView(listId: viewModel.listId, listName: listName)
        }
        .onAppear(perform: viewModel.fetchItems)
    }
}

struct ListItemsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ListItemsView(list: .init(name: "Lista"))
        }
        .previewInterfaceOrientation(.portrait)
    }
}
