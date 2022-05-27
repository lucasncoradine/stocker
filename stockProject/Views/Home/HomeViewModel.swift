import Foundation

class HomeViewModel: ObservableObject {
    private let client: ListsClient = .init()
    
    @Published var lists: [ListModel] = []
    @Published var isLoading: Bool = true
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    @Published var showEdit: Bool = false
    
    // MARK: - Private Methods
    private func requestFailed(message: String) {
        DispatchQueue.main.async {
            self.isLoading = false
            self.errorMessage = message
            self.showError = true
        }
    }
    
    // MARK: - Public Methods
    func getLists() {
        self.isLoading = true
        self.showError = false
        
        client.getLists(failure: requestFailed) { data in
            DispatchQueue.main.async {
                self.lists = data
                self.isLoading = false
            }
        }
    }
    
    func createList(with data: ListModel) {
        client.createList(data, failure: requestFailed) { response in
            DispatchQueue.main.async {
                self.lists.append(response)
            }
        }
    }
    
    func deleteLists(at offsets: IndexSet) {
        var idsToRemove = offsets.map { index in
            lists[index].id ?? ""
        }
        
        idsToRemove.removeAll { $0.isEmpty }
        
        lists.remove(atOffsets: offsets)
        client.deleteLists(idsToRemove, failure: requestFailed)
    }
}
