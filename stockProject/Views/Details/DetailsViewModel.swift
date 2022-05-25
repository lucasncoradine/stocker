//
//  DetailsViewModel.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 23/05/22.
//

import Foundation

class DetailsViewModel: ObservableObject {
    private let client: APIClient
    private let request: Request<Record<ListModel>>
    
    @Published var isLoading: Bool = true
    @Published var list: ListData = .init(label: "", type: .simple)
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    
    // MARK: - Lifecycle
    init() {
        self.client = APIClient()
        self.request = Request<Record<ListModel>>(client: client, path: "\(APIConstants.lists)")
    }
    
    // MARK: - Private Methods
    private func getDetailsFailed(error: String) {
        DispatchQueue.main.async {
            self.isLoading = false
            self.showError = true
            self.errorMessage = error
        }
    }
    
    private func getDetailsSucceeded(response: Record<ListModel>) {
        DispatchQueue.main.async {
            self.list = .init(recordId: response.id,
                              label: response.fields.name,
                              type: response.fields.type)
            
            self.isLoading = false
        }
    }
    
    // MARK: - Methods
    func getDetails(of recordId: String) {
        self.isLoading = true
        self.showError = false
        
        request
            .appendPath(recordId)
            .failure(getDetailsFailed)
            .success(getDetailsSucceeded)
            .perform()
    }
}
