//
//  ShoppingListViewModel.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 06/07/22.
//

import Foundation

class ShoppingListViewModel: ObservableObject {
    private let client: APIClient<ItemModel>
    private let listId: String
    
    @Published var items: [ItemModel] = []
    
    // MARK: Lifecycle
    init(listId: String) {
        client = APIClient(collection: .items(listId: listId))
        self.listId = listId
    }
    
    // MARK: - Private Methods
    func requestFailed(message: String) {
//        DispatchQueue.main.async {
//            self.isLoading = false
//            self.errorMessage = message
//        }
    }
    
    // MARK: - Methods
    func fetchItems() {
        let query: FirebaseQueryType = .isEqual(field: ItemModel.CodingKeys.inShoppingList.stringValue, to: true)
        
        client.fetch(query: query, failure: requestFailed) { data in
            self.items = data
        }
    }
    
    func remove(id: String?) {
        guard let id = id else { return }
        
        client.updateValue(id: id,
                           field: ItemModel.CodingKeys.inShoppingList.stringValue,
                           value: false,
                           failure: requestFailed)
    }
}
