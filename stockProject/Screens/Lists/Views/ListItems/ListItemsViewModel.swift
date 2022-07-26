//
//  ListItemsViewModel.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 01/07/22.
//

import Foundation
import SwiftUI

class ListItemsViewModel: ObservableObject {
    private let client: APIClient<ItemModel>
    private let shoppingClient: APIClient<ShoppingItemModel>
    let listId: String
    
    @Published var items: [ItemModel] = []
    @Published var isLoading: Bool = true
    @Published var errorMessage: String = ""
    @Published var selectedItem: ItemModel? = nil
    @Published var selection: Selection<String?> = .init()
    @Published var openEdit: Bool = false
    @Published var showAddedToast: Bool = false
    @Published var isEditing: Bool = false
    @Published var showDeleteConfirmation: Bool = false
    @Published var showBottomToolbar: Bool = false
    @Published var openShare: Bool = false
    
    // MARK: Lifecycle
    init(listId: String) {
        client = APIClient(collection: .items(listId: listId))
        shoppingClient = APIClient(collection: .shoppingList(listId: listId))
        self.listId = listId
    }
    
    // MARK: - Private Methods
    private func requestFailed(message: String) {
        DispatchQueue.main.async {
            self.isLoading = false
            self.errorMessage = message
            print(message) // TODO: Remove print
        }
    }
    
    private func toggleToast() {
        // Closes current toast if exists
        if showAddedToast {
            showAddedToast = false
        }
        
        doAfter(0.2) {
            self.showAddedToast = true
        }
    }
    
    // MARK: - Methods
    func fetchItems() {
        client.fetch(failure: requestFailed) { data in
            self.items = data
            self.isLoading = false
        }
    }
    
    func editItem(id: String?) {
        guard let id = id,
              let item = items.first(where: { $0.id == id })
        else { return }
        
        selectedItem = item
        openEdit = true
    }
    
    func createItem() {
        selectedItem = nil
        openEdit = true
    }
    
    func changeAmount(itemId: String?, itemName: String, newValue: Int) {
        guard let id = itemId else { return }
        
        client.updateValue(id: id,
                           field: ItemModel.CodingKeys.amount.stringValue,
                           value: newValue,
                           failure: requestFailed)
    }
    
    func addToShoppingList(itemId: String?, itemName: String, showToast: Bool = true) {
        guard let itemId = itemId else { return }
        
        let shoppingItem: ShoppingItemModel = .init(id: itemId, name: itemName)
        
        shoppingClient.save(id: shoppingItem.id!, with: shoppingItem, failure: requestFailed, forceUpdate: true)
        
        if showToast {
            toggleToast()
        }
    }
    
    func deleteItem(id: String?) {
        guard let id = id else { return }
        client.delete(id: id, failure: requestFailed)
    }
    
    func deleteSelectedItems() {
        let idsToRemove: [String] = selection.asArray()
        client.delete(ids: idsToRemove, failure: requestFailed)
        showDeleteConfirmation = false
        toggleSelection()
    }
    
    func addSelectedToShoppingList() {
        let items: [ItemModel] = self.items.filter { selection.contains($0.id) }
        
        items.forEach { item in
            addToShoppingList(itemId: item.id, itemName: item.name, showToast: false)
        }
        
        toggleToast()
        toggleSelection()
    }
    
    func toggleSelection() {
        withAnimation {
            UITabBar.toggleTabBarVisibility(animated: false)
            isEditing.toggle()
            showBottomToolbar.toggle()
        }
    }
    
    func toggleAll() {
        let isAllSelected: Bool = selection.count == items.count
        
        if isAllSelected {
            selection.removeAll()
        } else {
            let nonSelectedItems = items.filter { selection.contains($0.id) == false }
            let ids = nonSelectedItems.map { $0.id }
            
            selection.toggleMultiple(ids)
        }
    }
}
