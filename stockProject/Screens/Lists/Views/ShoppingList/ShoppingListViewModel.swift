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
        self.listId = listId
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
        guard !newItemName.isEmpty else {
            creatingNewItem = false
            return
        }
        
        let item = ShoppingItemModel(name: self.newItemName)
        self.newItemName = ""
        
        if !keepCreating {
            self.creatingNewItem = false
        }
        
        client.create(with: item) { message in
            self.requestFailed(message)
            self.newItemName = item.name
        } success: { _ in }
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
}
