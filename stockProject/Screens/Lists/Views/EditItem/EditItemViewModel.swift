//
//  EditItemViewModel.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 05/07/22.
//

import Foundation

class EditItemViewModel: ObservableObject {
    private let client: APIClient<ItemModel>
    private let listId: String
    
    @Published var item: ItemModel
    @Published var showFieldRequired: Bool = false
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    @Published var hasExpirationDate: Bool
    @Published var expirationDate: Date
    
    // MARK: - Private Methods
    private func requestFailed(message: String) {
        DispatchQueue.main.async {
            self.errorMessage = message
            self.showError = true
        }
    }
    
    // MARK: - Lifecycle
    init(from listId: String, with model: ItemModel) {
        self.client = .init(collection: .items(listId: listId))
        self.listId = listId
        self.item = model
        self.hasExpirationDate = model.expirationDate != nil
        self.expirationDate = model.expirationDate ?? Date()
    }
    
    // MARK: - Methods
    func saveItem(_ completion: () -> Void) {
        guard
            item.name.isEmpty == false,
            let id = item.id
        else {
            showFieldRequired = true
            return
        }
        
        item.expirationDate = hasExpirationDate ? expirationDate : nil
        
        client.save(id: id, with: item, failure: requestFailed)
        completion()
    }
}
