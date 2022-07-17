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
            let selectedWord: String = selectedCount > 1 ? "Selecionados" : "Selecionado"
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
                            Text("Lista de compras")
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
                                Label("Comprar", systemImage: "cart.badge.plus")
                            }
                            
                            Button(action: { viewModel.editItem(id: item.id) }) {
                                Label("Editar", systemImage: "square.and.pencil")
                            }
                            
                            Button(role: .destructive, action: { viewModel.deleteItem(id: item.id) }) {
                                Label("Remover", systemImage: "trash")
                            }
                        }
                        // MARK: - Right Swipe
                        .swipeActions {
                            Button(role: .destructive, action: { viewModel.deleteItem(id: item.id) } ) {
                                Label("Remover", systemImage: "trash")
                            }
                        }
                        
                        // MARK: - Left Swipe
                        .swipeActions(edge: .leading) {
                            Button(action: { viewModel.addToShoppingList(itemId: item.id, itemName: item.name) }) {
                                Label("Comprar", systemImage: "cart.badge.plus")
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
            .alert("Tem certeza que deseja remover os itens selecionados?", isPresented: $viewModel.showDeleteConfirmation, actions: {
                Button(role: .cancel , action: {}) {
                    Text("Cancelar")
                }
                
                Button(role: .destructive, action: { viewModel.deleteSelectedItems() }) {
                    Text("Remover")
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
        .showEmptyView(viewModel.items.isEmpty, emptyText: "Sem itens")
        .showLoading(viewModel.isLoading)
        .toast(isShowing: $viewModel.showAddedToast, message: "Adicionado à lista de compras")
        .navigationTitle(navigationTitle())
        .bottomToolbar(visible: viewModel.showBottomToolbar) {
            HStack {
                BottomToolbarItem(action: viewModel.addSelectedToShoppingList) {
                    Label("Comprar", systemImage: "cart.badge.plus")
                }
                
                BottomToolbarItem(action: { viewModel.showDeleteConfirmation.toggle() }) {
                    Label("Remover", systemImage: "trash")
                }
            }
        }
        .navigationBarBackButtonHidden(viewModel.isEditing)
        .toolbar {
            ToolbarItemGroup() {
                if !viewModel.isEditing {
                    HStack {
                        Button(action: viewModel.createItem) {
                            Label("Novo item", systemImage: "plus")
                        }
                        
                        Menu {
                            Button(action: viewModel.toggleSelection) {
                                Text("Selecionar")
                                Image(systemName: "checkmark.circle")
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
                        Text("Selecionar Tudo")
                    }
                }
            }
            
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                if viewModel.isEditing {
                    Button(action: viewModel.toggleSelection) {
                        Text("OK")
                            .bold()
                    }
                }
            }
            
            // MARK: - Keyboard Toolbar
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                
                Button("Done") {
                    counterFocused = false
                }
            }
        }
        .sheet(isPresented: $viewModel.openEdit) {
            EditItemView(listId: viewModel.listId, item: viewModel.selectedItem)
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
