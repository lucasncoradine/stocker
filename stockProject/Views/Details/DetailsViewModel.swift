//
//  DetailsViewModel.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 23/05/22.
//

import Foundation

class DetailsViewModel: ObservableObject {
    private let client: APIClient
    private let request: Request<ListModel>
    
    @Published var isLoading: Bool = true
    @Published var list: ListModel? = nil
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    
    // MARK: - Lifecycle
    init() {
        self.client = APIClient()
        self.request = Request<ListModel>(client: client, path: "\(APIConstants.lists)")
    }
    
    // MARK: - Private Methods
    private func getDetailsFailed(error: String) {
        DispatchQueue.main.async {
            self.isLoading = false
            self.showError = true
            self.errorMessage = error
        }
    }
    
    private func getDetailsSucceeded(response: ListModel) {
        DispatchQueue.main.async {
            self.list = response
            self.isLoading = false
        }
    }
    
    // MARK: - Methods
    func getDetails(of listId: UUID) {
        self.isLoading = true
        self.showError = false
        
        request
            .appendPath(listId.uuidString)
            .failure(getDetailsFailed)
            .success(getDetailsSucceeded)
            .perform()
    }
}
