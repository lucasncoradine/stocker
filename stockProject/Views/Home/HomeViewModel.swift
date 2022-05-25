import Foundation

class HomeViewModel: ObservableObject {
    private let client: APIClient
    private let request: Request<[ListModel]>
    
    @Published var lists: [ListModel] = []
    @Published var isLoading: Bool = true
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    
    init() {
        self.client = APIClient()
        self.request = Request<[ListModel]>(client: client, path: APIConstants.lists)
    }
    
    // MARK: - Private Methods
    private func getListSucceeded(response: [ListModel]) {
        DispatchQueue.main.async {
            self.lists = response
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
