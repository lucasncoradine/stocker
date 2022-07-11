//
//  ShoppingListViewModel.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 06/07/22.
//

import Foundation

class ShoppingListViewModel: ObservableObject {
    private let client: APIClient<ShoppingItemModel>
    private let listId: String
    
    @Published var shoppingItems: [ShoppingItemModel] = []
    @Published var isLoading: Bool = true
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    @Published var showClearConfirmation: Bool = false
    
    // MARK: Lifecycle
    init(listId: String) {
        client = APIClient(collection: .shoppingList(listId: listId))
        self.listId = listId
    }
    
    // MARK: - Private Methods
    func requestFailed(message: String) {
        DispatchQueue.main.async {
            self.isLoading = false
            self.errorMessage = message
            self.showError = true
        }
    }
    
    // MARK: - Methods
    func fetchItems() {
        client.fetch(failure: requestFailed) { data in
            self.shoppingItems = data
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
    
    func remove(id: String?) {
        guard let id = id else { return }
        client.delete(id: id, failure: requestFailed)
    }
}
