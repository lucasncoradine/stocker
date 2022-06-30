//
//  ItemViewModel.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 30/06/22.
//

import Foundation

class ItemViewModel: ObservableObject {
    private let client: ListsClient = .init()
    
    @Published var list: ListModel
    @Published var isLoading: Bool = true
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    @Published var hasItems: Bool = false
    
    // MARK: - Private Methods
    private func requestFailed(message: String) {
        DispatchQueue.main.async {
            self.isLoading = false
            self.errorMessage = message
            self.showError = true
        }
    }
}
