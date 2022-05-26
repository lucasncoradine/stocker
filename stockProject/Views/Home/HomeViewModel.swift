import Foundation

class HomeViewModel: ObservableObject {
    private let client: FirebaseClient
    
    @Published var lists: [ListModel] = []
    @Published var isLoading: Bool = true
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    
    init() {
        self.client = FirebaseClient()
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
        
        client.getLists(success: getListSucceeded,
                      failure: getListsFailed)
    }
}
