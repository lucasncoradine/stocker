//
//  ListItemsViewModel.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 01/07/22.
//

import Foundation

class ListItemsViewModel: ObservableObject {
    private let client: ListsClient = .init(userId: dev_userId)
    let listId: String
    
    @Published var items: [ItemModel] = []
    @Published var isLoading: Bool = true
    @Published var errorMessage: String = ""
    
    // MARK: Lifecycle
    init(listId: String) {
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
        client.fetchItems(of: listId, failure: requestFailed) { data in
            DispatchQueue.main.async {
                self.items = data
                self.isLoading = false
            }
        }
    }
}
