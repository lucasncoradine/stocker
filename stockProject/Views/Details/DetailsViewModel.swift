//
//  DetailsViewModel.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 23/05/22.
//

import Foundation

class DetailsViewModel: ObservableObject {
    private let client: ListsClient = .init()
    private let onChangeClosure: (_ newData: ListModel) -> Void
    private var listHasChanged: Bool = false
    
    @Published var list: ListModel
    @Published var isLoading: Bool = true
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    @Published var hasItems: Bool = false
    
    init(list: ListModel, onChange: @escaping (_ newData: ListModel) -> Void) {
        self.list = list
        self.onChangeClosure = onChange
    }
    
    // MARK: - Private Methods
    private func requestFailed(message: String) {
        DispatchQueue.main.async {
            self.isLoading = false
            self.errorMessage = message
            self.showError = true
        }
    }
    
    // MARK: - Methods
    func updateItemAmount(id: Int, with value: Int) {
        guard let index = list.items.firstIndex(where: { $0.id == id })
        else { return }
        
        list.items[index].amount = value
        listHasChanged = true
    }
    
    func saveList() {
        guard
            listHasChanged == true,
            let id = list.id
        else { return }
        
        client.updateList(id, with: list, failure: requestFailed)
        onChangeClosure(list)
    }
}
