//
//  EditItemViewModel.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 05/07/22.
//

import Foundation

enum EditItemField: FormViewModelField {
    case name
    case description
    case expireDate
    
    var description: String {
        switch self {
        case .name: return Strings.name
        case .description: return Strings.description
        case .expireDate: return Strings.expireDate
        }
    }
}

class EditItemViewModel: FormViewModelProtocol {
    private let client: APIClient<ItemModel>
    private let listId: String
    
    @Published var item: ItemModel
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    @Published var hasExpirationDate: Bool
    @Published var expirationDate: Date
    @Published var validations: Validations = [:]
    @Published var isLoading: Bool = false
    
    func requestFailed(_ message: String) {
        self.errorMessage = message
        self.showError = true
    }
    
    func validateFields() -> Bool {
        validations.requiredField(key: EditItemField.name.description, value: self.item.name)
        
        return validations.noErrors()
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
            validateFields(),
            let id = item.id
        else {
            return
        }
        
        item.expirationDate = hasExpirationDate ? expirationDate : nil
        
        client.save(id: id, with: item, failure: requestFailed)
        completion()
    }
}
