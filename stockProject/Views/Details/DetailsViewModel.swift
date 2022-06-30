//
//  DetailsViewModel.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 23/05/22.
//

import Foundation
import SwiftUI

class DetailsViewModel: ObservableObject {
    private let client: ListsClient = .init()
    private let onChangeClosure: (_ newData: ListModel) -> Void
        
    @Published var list: ListModel
    @Published var isLoading: Bool = true
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    @Published var hasItems: Bool = false
    @Published var selectedItem: ListItemModel = .init()
    @Published var showItemDetails: Bool = false
    @Published var listHasChanged: Bool = false
    
    // MARK: - Lifecycle
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
    func openEdit(of item: ListItemModel? = nil) {
        selectedItem = item ?? .init()
        showItemDetails = true
    }
    
    func saveItem(_ item: ListItemModel) {
        if let index = list.items.firstIndex(where: { $0.id == item.id }) {
            list.items[index] = item
        } else {
            list.items.append(item)
        }
    }
    
    func deleteItems(at offsets: IndexSet) {        
        list.items.remove(atOffsets: offsets)
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
