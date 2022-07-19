//
//  EditListView.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 05/07/22.
//

import Foundation

enum EditListField: FormViewModelField {
    case listName
    
    var description: String {
        switch self {
        case .listName: return Strings.editListFieldName
        }
    }
}

class EditListViewModel: FormViewModelProtocol {
    private let client: APIClient<ListModel> = .init(collection: .lists)
    
    @Published var list: ListModel
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    @Published var validations: Validations = [:]
    @Published var isLoading: Bool = false
    
    // MARK: - Private Methods
    func requestFailed(_ message: String) {
        DispatchQueue.main.async {
            self.errorMessage = message
            self.showError = true
        }
    }
    
    func validateFields() -> Bool {
        validations.requiredField(key: EditListField.listName.description, value: self.list.name)
        
        return validations.noErrors()
    }
    
    // MARK: - Lifecycle
    init(with list: ListModel) {
        self.list = list
    }
    
    // MARK: - Methods
    func saveList(_ completion: () -> Void) {
        guard
            validateFields(),
            let id = list.id
        else {
            return
        }
        
        client.save(id: id, with: list, failure: requestFailed)
        completion()
    }
}
