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
    
    // MARK: Lifecycle
    init(listId: String, listName: String) {
        self._viewModel = StateObject(wrappedValue: .init(listId: listId))
        self.listName = listName
        
        UITableView.appearance().isScrollEnabled = false
    }
    
    func navigationTitle() -> String {
        let selectedCount: Int = viewModel.selection.count
        
        if selectedCount == 0 {
            return listName
        } else {
            let selectedWord: String = selectedCount > 1 ? "Selecionados" : "Selecionado"
            return "\(selectedCount) \(selectedWord)"
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if viewModel.items.isEmpty {
                EmptyView(text: "Sem itens")
            } else {
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
                                    let selected: Bool = viewModel.selection.contains(item.id)
                                    
                                    Image(systemName: selected ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(selected ? .blue : .gray)
                                }
                                
                                Stepper(label: item.name,
                                        amount: item.amount,
                                        description: item.description,
                                        counterFocused: _counterFocused
                                ) { value in
                                    viewModel.changeAmount(itemId: item.id, newValue: value)
                                }
                                .disabled(viewModel.isEditing)
                                .buttonStyle(.plain)
                                .contextMenu {
                                    Button(action: { viewModel.addToShoppingList(itemId: item.id) }) {
                                        Label("Comprar", systemImage: "cart.badge.plus")
                                    }
                                    
                                    Button(action: { viewModel.editItem(item) }) {
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
                                    Button(action: { viewModel.addToShoppingList(itemId: item.id) }) {
                                        Label("Comprar", systemImage: "cart.badge.plus")
                                    }
                                    .tint(.blue)
                                }
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
                    Button("Não") { viewModel.showDeleteConfirmation = false }
                    
                    Button(action: { viewModel.deleteSelectedItems() }) {
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
        }
        .sheet(isPresented: $viewModel.openEdit) {
            EditItemView(listId: viewModel.listId, item: viewModel.selectedItem)
        }
        .showLoading(viewModel.isLoading)
        .toast(isShowing: $viewModel.showAddedToast, message: "Adicionado à lista de compras")
        .navigationTitle(navigationTitle())
        .toolbar {
            ToolbarItemGroup {
                if viewModel.isEditing {
                    Button(action: viewModel.toggleSelection) {
                        Text("OK")
                            .bold()
                    }
                } else {
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
            
            // MARK: - Bottom Toolbar
            ToolbarItemGroup(placement: .bottomBar) {
                if viewModel.isEditing == true {
                    let disabled: Bool = viewModel.selection.count == 0
                    
                    Button(action: viewModel.selectAll) {
                        Text("Todos")
                    }
                    
                    Spacer()
                    
                    Button(action: viewModel.addSelectedToShoppingList) {
                        Text("Comprar")
                    }
                    .disabled(disabled)
                    
                    Spacer()
                    
                    Button(role: .destructive, action: { viewModel.showDeleteConfirmation.toggle() }) {
                        Text("Remover")
                    }
                    .disabled(disabled)
                } else {
                    Button(action: viewModel.createItem) {
                        Image(systemName: "plus")
                        Text("Novo item")
                    }
                    
                    Spacer()
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
