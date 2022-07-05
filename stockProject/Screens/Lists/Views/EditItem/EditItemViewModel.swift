//
//  EditItemViewModel.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 05/07/22.
//

import Foundation

class EditItemViewModel: ObservableObject {
    private let client: ListsClient = .init()
    private let listId: String
    
    @Published var item: ItemModel
    @Published var showFieldRequired: Bool = false
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    
    // MARK: - Private Methods
    private func requestFailed(message: String) {
        DispatchQueue.main.async {
            self.errorMessage = message
            self.showError = true
        }
    }
    
    // MARK: - Lifecycle
    init(from listId: String, with model: ItemModel) {
        self.listId = listId
        self.item = model
    }
    
    // MARK: - Methods
    func saveItem(_ completion: () -> Void) {
        guard item.name.isEmpty == false
        else {
            showFieldRequired = true
            return
        }
        
        client.saveItem(with: item, listId: listId, failure: requestFailed)
        completion()
    }
}
