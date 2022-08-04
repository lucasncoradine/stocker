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
    private func validateListName(completion: @escaping () -> Void) {
        client.valueExists(list.name,
                           field: ListModel.CodingKeys.name.stringValue,
                           failure: self.requestFailed) { exists in
            if exists {
                self.requestFailed(Strings.editItemNameExists)
            } else {
                completion()
            }
        }
    }
    
    // MARK: - Lifecycle
    init(with list: ListModel) {
        self.list = list
    }
    
    // MARK: - Methods
    func validateFields() -> Bool {
        validations.requiredField(key: EditListField.listName.description, value: self.list.name)
        
        return validations.noErrors()
    }
    
    func saveList(_ completion: @escaping () -> Void) {
        guard
            validateFields(),
            let id = list.id
        else {
            return
        }
        
        validateListName {
            self.client.save(id: id, with: self.list, failure: self.requestFailed)
            completion()
        }
    }
}
