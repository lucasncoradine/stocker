import Foundation

class HomeViewModel: ObservableObject {
    private let client: APIClient
    private let request: Request<ListData>
    
    @Published var lists: [HomeTableData] = []
    @Published var isLoading: Bool = true
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    
    init() {
        self.client = APIClient()
        self.request = Request<ListData>(client: client, path: APIConstants.lists)
    }
    
    func getLists() {
        self.isLoading = true
        self.showError = false
        
        request
            .failure { message in
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.showError = true
                    self.errorMessage = message
                }
            }
            .success { response in
                DispatchQueue.main.async {
                    self.lists = response.records.map { record in
                        HomeTableData(
                            id: record.fields.id,
                            label: record.fields.name,
                            isStock: record.fields.type == .stock
                        )
                    }
                    
                    self.isLoading = false
                }
                
            }
            .perform()
    }
}
