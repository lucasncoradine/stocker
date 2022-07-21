//
//  ListItemsView.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 01/07/22.
//

import SwiftUI

struct ListItemsView: View {
    private let listName: String
    
    @StateObject var viewModel: ListItemsViewModel
    @FocusState var counterFocused: Bool
    
    // MARK: - Lifecycle
    init(listId: String, listName: String) {
        self._viewModel = StateObject(wrappedValue: .init(listId: listId))
        self.listName = listName
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
            .listStyle(.insetGrouped)
            .onChange(of: viewModel.isEditing) { value in
                if value == false {
                    viewModel.selection.removeAll()
                }
            }
        }
        .showEmptyView(viewModel.items.isEmpty, emptyText: Strings.listItemsEmpty)
        .showLoading(viewModel.isLoading)
        .toast(isShowing: $viewModel.showAddedToast, message: Strings.listItemsAddedToast)
        .bottomToolbar(visible: viewModel.showBottomToolbar) {
            HStack {
                BottomToolbarItem(action: viewModel.addSelectedToShoppingList) {
                    Label(Strings.addToShopping, systemImage: "cart.badge.plus")
                }
                
                BottomToolbarItem(action: { viewModel.openShare.toggle() }) {
                    Label(Strings.remove, systemImage: "trash")
                }
            }
        }
        .navigationTitle(navigationTitle())
        .navigationBarBackButtonHidden(viewModel.isEditing)
        .toolbar {
            ToolbarItemGroup() {
                if !viewModel.isEditing {
                    HStack {
                        Button(action: viewModel.createItem) {
                            Label(Strings.editItemNavigationTitle, systemImage: "plus")
                        }
                        
                        Menu {
                            Button(action: viewModel.toggleSelection) {
                                Label(Strings.select, systemImage: "checkmark.circle")
                            }
                            
                            Button(action: { viewModel.openShare.toggle() }) {
                                Label(Strings.share, systemImage: "square.and.arrow.up")
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
        .sheet(isPresented: $viewModel.openEdit) {
            EditItemView(listId: viewModel.listId, item: viewModel.selectedItem)
        }
        .sheet(isPresented: $viewModel.openShare) {
            ShareListView(listId: viewModel.listId, listName: listName)
        }
        .onAppear(perform: viewModel.fetchItems)
    }
}

struct ListItemsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ListItemsView(listId: "SF6jqiRauIkLSTurDy15", listName: "Estoque")
        }
        .previewInterfaceOrientation(.portrait)
    }
}
