//
//  DetailsListViewModel.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 24/05/22.
//

import Foundation

class DetailsListViewModel: ObservableObject {
    private let client: APIClient
    private let request: Request<Response<ListItem>>
    
    @Published var isLoading: Bool = true
    @Published var items: [DetailsListData] = []
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    
    // MARK: - Lifecycle
    init() {
        self.client = APIClient()
        self.request = Request<Response<ListItem>>(client: client, path: "\(APIConstants.items)")
    }
    
    // MARK: - Private Methods
    private func getItemsFailed(error: String) {
        DispatchQueue.main.async {
            self.isLoading = false
            self.errorMessage = error
            self.showError = true
        }
    }
    
    private func getItemsSucceeded(response: Response<ListItem>) {
        DispatchQueue.main.async {
            self.items = response.records.map { item in
                DetailsListData(recordId: item.id,
                                label: item.fields.name,
                                amount: item.fields.amount)
            }
            
            self.isLoading = false
        }
    }
    
    // MARK: - Methods
    func getItems(of listId: String) {
        self.isLoading = true
        self.showError = false
        
        request
            .cleanQuery()
            .filterBy(key: "list_id", value: listId)
            .failure(getItemsFailed)
            .success(getItemsSucceeded)
            .perform()
    }
}
