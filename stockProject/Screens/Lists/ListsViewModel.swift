//
//  ListsViewModel.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 01/07/22.
//

import Foundation
import CodeScanner
import UIKit

struct UserLists {
    var owned: [ListModel] = []
    var shared: [ListModel] = []
}

class ListsViewModel: ViewModel {
    private let client: APIClient<ListModel> = .init(collection: .lists)
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    @Published var lists: UserLists = .init()
    @Published var showError: Bool = false
    @Published var showEditSheet: Bool = false
    @Published var selectedList: ListModel? = nil
    @Published var showShareSheet: Bool = false
    @Published var selectedSharedList: String? = nil
    
    var listsAreEmpty: Bool {
        return self.lists.owned.isEmpty && self.lists.shared.isEmpty
    }
    
    // MARK: - Private Methods
    private func fetchOwnedLists() {
        guard let userId = AuthManager.shared.user?.uid else { return }
        
        let createdByField: String = ListModel.CodingKeys.createdBy.stringValue
        
        client.fetch(query: .isEqual(field: createdByField, to: userId), failure: self.requestFailed) { data in
            self.lists.owned = data
        }
    }
    
    private func fetchSharedLists() {
        guard let userId = AuthManager.shared.user?.uid else { return }
        
        let sharedWithField: String = ListModel.CodingKeys.sharedWith.stringValue
        
        client.fetch(query: .contains(field: sharedWithField, value: userId), failure: self.requestFailed) { data in
            self.lists.shared = data
        }
    }
    
    // MARK: - Methods
    func fetchLists() {
        fetchOwnedLists()
        fetchSharedLists()
    }
    
    func reloadList() {
        client.stopListeners()
        fetchLists()
    }
    
    func editList(_ list: ListModel) {
        selectedList = list
        showEditSheet = true
    }
    
    func shareList(_ list: ListModel) {
        selectedList = list
        showShareSheet = true
    }
    
    func createList() {
        selectedList = nil
        showEditSheet = true
    }
    
    func deleteList(id: String?) {
        guard let id = id else { return }
        client.delete(id: id, failure: requestFailed)
    }
    
    func handleQrCodeScan(_ result: ScanResult) {
        let message = Strings.scannerInvalidQrCode
        
        guard let url = result.url(),
              let target = DeeplinkTarget.getFromUrl(url)
        else {
            requestFailed(message)
            return
        }
        
        if target.path == .invite {
            guard let listId = target.params["listId"],
                  let userId = AuthManager.shared.user?.uid
            else {
                requestFailed(message)
                return
            }
            
            client.addValuesToArrayField(id: listId,
                                          field: ListModel.CodingKeys.sharedWith.stringValue,
                                          values: [userId],
                                          failure: requestFailed)
            
            self.selectedSharedList = listId
        }
    }
}
