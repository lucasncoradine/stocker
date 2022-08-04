//
//  ShoppingListViewModel.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 06/07/22.
//

import Foundation
import UIKit

class ShoppingListViewModel: ViewModel {
    private let client: APIClient<ShoppingItemModel>
    private let itemsClient: APIClient<ItemModel>
    private let listId: String
    
    @Published var shoppingItems: [ShoppingItemModel] = []
    @Published var isLoading: Bool = true
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    @Published var showClearConfirmation: Bool = false
    @Published var creatingNewItem: Bool = false
    @Published var newItemName: String = ""
    @Published var editingItem: String? = nil
    
    // MARK: Lifecycle
    init(listId: String) {
        client = APIClient(collection: .shoppingList(listId: listId))
        itemsClient = APIClient(collection: .items(listId: listId))
        self.listId = listId
    }
    
    private func validateNewItem(name: String, completion: @escaping () -> Void) {
        let alreadyCreated: Bool = shoppingItems.contains(where: { $0.name == name })
        
        if alreadyCreated {
            self.requestFailed(Strings.shoppingListItemNameExists)
            return
        }
        
        // Checks if there is any item with the same name
        itemsClient.valueExists(name,
                           field: ShoppingItemModel.CodingKeys.name.stringValue,
                           failure: requestFailed) { exists in
            if exists {
                self.requestFailed(Strings.shoppingListItemNameExistsStock)
            } else {
                completion()
            }
        }
    }
    
    // MARK: - Methods
    func fetchItems() {
        client.fetch(failure: requestFailed) { data in
            self.shoppingItems = data.sorted(.alphabetically)
            self.isLoading = false
        }
    }
    
    func reload() {
        client.stopListeners()
        fetchItems()
    }
    
    func checkItem(_ id: String?, checked: Bool) {
        guard let id = id else { return }
        
        client.updateValue(id: id,
                           field: ShoppingItemModel.CodingKeys.checked.stringValue,
                           value: checked,
                           failure: requestFailed)
    }
    
    func clearList() {
        shoppingItems.forEach { item in
            guard let id = item.id else { return }
            client.delete(id: id, failure: requestFailed)
        }
    }
    
    func toggleNewItem() {
        creatingNewItem.toggle()
        newItemName = ""
    }
    
    func create(keepCreating: Bool = false) {
        guard newItemName.isEmpty == false else {
            creatingNewItem = false
            return
        }
        
        validateNewItem(name: newItemName) {
            let item = ShoppingItemModel(name: self.newItemName)
            self.newItemName = ""
            
            if !keepCreating {
                self.creatingNewItem = false
            }
            
            self.client.create(with: item) { message in
                self.requestFailed(message)
                self.newItemName = item.name
            } success: { _ in }
        }
    }
    
    func remove(id: String?) {
        guard let id = id else { return }
        client.delete(id: id, failure: requestFailed)
    }
    
    func save(id: String?) {
        guard let id = id,
              let item = shoppingItems.first(where: { $0.id == id })
        else { return }
        
        client.save(id: id, with: item, failure: self.requestFailed)
    }
    
    func rename() {
        guard let editingItem = editingItem else { return }
        
        save(id: editingItem)
        self.editingItem = nil
        UIApplication.shared.dismissKeyboard()
    }
    
    func changeAmount(id: String?, newValue: Int) {
        guard let id = id else { return }
        
        client.updateValue(id: id,
                           field: ShoppingItemModel.CodingKeys.amount.stringValue,
                           value: newValue,
                           failure: self.requestFailed)
    }
    
    func completeShoppingList() {
        var checkedItems: [String: ItemModel] = [:]
        var checkedIds: [String] = []
        
        shoppingItems.forEach { item in
            guard item.checked, let id = item.id else { return }
            checkedItems[id] = ItemModel(id: id, name: item.name, amount: item.amount)
            checkedIds.append(id)
        }
        
        itemsClient.save(all: checkedItems, failure: requestFailed)
        client.delete(ids: checkedIds, failure: requestFailed)
    }
}
