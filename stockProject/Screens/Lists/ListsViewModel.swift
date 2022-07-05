//
//  ListsViewModel.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 01/07/22.
//

import Foundation

class ListsViewModel: ObservableObject {
    private let client: ListsClient = .init()
    
    @Published var isLoading: Bool = true
    @Published var errorMessage: String = ""
    @Published var lists: [ListModel] = []
    @Published var showError: Bool = false
    @Published var showEditSheet: Bool = false
    @Published var selectedList: ListModel? = nil
    
    // MARK: - Private Methods
    private func requestFailed(message: String) {
        DispatchQueue.main.async {
            self.isLoading = false
            self.errorMessage = message
            self.showError = true
        }
    }
    
    // MARK: - Methods
    func fetchLists() {
        isLoading = true
        
        client.fetchLists(of: dev_userId, failure: requestFailed) { data in
            DispatchQueue.main.async {
                self.lists = data
                self.isLoading = false
            }
        }
    }
    
    func reloadList() {
        client.stopListeners()
        fetchLists()
    }
    
    func editList(_ list: ListModel) {
        showEditSheet = true
        selectedList = list
    }
    
    func deleteList(id: String?) {
        guard let id = id else { return }
        client.deleteList(id: id, failure: requestFailed)
    }
}
