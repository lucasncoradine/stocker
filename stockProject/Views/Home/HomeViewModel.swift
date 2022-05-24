import Foundation

class HomeViewModel: ObservableObject {
    private let client: APIClient
    private let request: Request<Response<ListData>>
    
    @Published var lists: [HomeTableData] = []
    @Published var isLoading: Bool = true
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    
    init() {
        self.client = APIClient()
        self.request = Request<Response<ListData>>(client: client, path: APIConstants.lists)
    }
    
    // MARK: - Private Methods
    private func getListSucceeded(response: Response<ListData>) {
        DispatchQueue.main.async {
            self.lists = response.records.map { record in
                HomeTableData(
                    recordId: record.id,
                    label: record.fields.name,
                    isStock: record.fields.type == .stock
                )
            }
            
            self.isLoading = false
        }
    }
    
    private func getListsFailed(message: String) {
        DispatchQueue.main.async {
            self.isLoading = false
            self.showError = true
            self.errorMessage = message
        }
    }
    
    // MARK: - Public Methods
    func getLists() {
        self.isLoading = true
        self.showError = false
        
        request
            .failure(getListsFailed)
            .success(getListSucceeded)
            .perform()
    }
}
