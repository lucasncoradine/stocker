//
//  ListItemsViewModel.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 01/07/22.
//

import Foundation

enum AmountChangeType {
    case increment
    case decrement
    case custom(value: Int)
    
    var value: Int {
        switch self {
        case .increment:
            return 1
        case .decrement:
            return -1
        case .custom(let value):
            return value
        }
    }
}

class ListItemsViewModel: ObservableObject {
    private let client: APIClient<ItemModel>
    let listId: String
    
    @Published var items: [ItemModel] = []
    @Published var isLoading: Bool = true
    @Published var errorMessage: String = ""
    @Published var selectedItem: ItemModel? = nil
    @Published var openEdit: Bool = false
    
    // MARK: Lifecycle
    init(listId: String) {
        client = APIClient(collection: .items(listId: listId))
        self.listId = listId
    }
    
    // MARK: - Private Methods
    func requestFailed(message: String) {
        DispatchQueue.main.async {
            self.isLoading = false
            self.errorMessage = message
            print(message) // TODO: Remove print
        }
    }
    
    // MARK: - Methods
    func fetchItems() {
        client.fetch(failure: requestFailed) { data in
            self.items = data
            self.isLoading = false
        }
    }
    
    func editItem(_ item: ItemModel) {
        selectedItem = item
        openEdit = true
    }
    
    func createItem() {
        selectedItem = nil
        openEdit = true
    }
    
    func changeAmount(itemId: String?, newValue: Int) {
        guard let id = itemId else { return }
        
        client.updateValue(id: id,
                           field: ItemModel.CodingKeys.amount.stringValue,
                           value: newValue,
                           failure: requestFailed)
    }
    
    func addToShoppingList(itemId: String?) {
        guard let id = itemId else { return }
        
        client.updateValue(id: id,
                           field: ItemModel.CodingKeys.inShoppingList.stringValue,
                           value: true,
                           failure: requestFailed)
    }
    
    func deleteItem(id: String?) {
        guard let id = id else { return }
        client.delete(id: id, failure: requestFailed)
    }
}
