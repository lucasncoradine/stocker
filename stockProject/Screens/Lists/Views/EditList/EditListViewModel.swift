//
//  EditListView.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 05/07/22.
//

import Foundation

class EditListViewModel: ObservableObject {
    private let client: APIClient<ListModel> = .init(collection: .lists)
    
    @Published var list: ListModel
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    @Published var showNameFieldError: Bool = false
    
    // MARK: - Private Methods
    private func requestFailed(message: String) {
        DispatchQueue.main.async {
            self.errorMessage = message
            self.showError = true
        }
    }
    
    // MARK: - Lifecycle
    init(with list: ListModel) {
        self.list = list
    }
    
    // MARK: - Methods
    func saveList(_ completion: () -> Void) {
        guard
            list.name.isEmpty == false,
            let id = list.id
        else {
            showNameFieldError = true
            return
        }
        
        client.save(id: id, with: list, failure: requestFailed)
        completion()
    }
}
