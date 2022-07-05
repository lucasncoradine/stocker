//
//  ListItemsViewModel.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 01/07/22.
//

import Foundation

class ListItemsViewModel: ObservableObject {
    private let client: ListsClient = .init()
    let listId: String
    
    @Published var items: [ItemModel] = []
    @Published var isLoading: Bool = true
    @Published var errorMessage: String = ""
    @Published var selectedItem: ItemModel? = nil
    @Published var openEdit: Bool = false
    
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
    
    func editItem(_ item: ItemModel) {
        selectedItem = item
        openEdit = true
    }
    
    func createItem() {
        selectedItem = nil
        openEdit = true
    }
    
    func deleteItem(id: String?) {
        guard let id = id else { return }
        client.deleteItem(id: id, listId: listId, failure: requestFailed)
    }
}
