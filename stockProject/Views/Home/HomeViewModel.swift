import Foundation

class HomeViewModel: ObservableObject {
    private let client: ListsClient = .init()
    
    @Published var lists: [ListModel] = []
    @Published var isLoading: Bool = true
    @Published var errorMessage: String = ""
    @Published var listOpenForEdit: ListModel? = nil
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
                self.lists = data.sorted { $0.name < $1.name }
                self.isLoading = false
            }
        }
    }
    
    func saveList(with data: ListModel) {
        guard listOpenForEdit != nil,
              let id = listOpenForEdit?.id
        else {
            client.createList(data, failure: requestFailed) { response in
                DispatchQueue.main.async {
                    self.lists.append(response)
                }
            }
            return
        }
        
        let index = lists.firstIndex(where: { $0.id == id })
        
        guard let index = index else { return }
        lists[index] = data
        client.updateList(id, with: data, failure: requestFailed)
    }
    
    func deleteLists(at offsets: IndexSet) {
        let idsToRemove = offsets.map { index in
            lists[index].id!
        }
        
        lists.remove(atOffsets: offsets)
        client.deleteLists(idsToRemove, failure: requestFailed)
    }
    
    func deleteList(_ item: ListModel) {
        guard let index = lists.firstIndex(where: { $0.id == item.id }) else { return }
        deleteLists(at: IndexSet(integer: index))
    }
    
    func openEdit(id: String? = nil) {
        self.listOpenForEdit = nil
        
        if let id = id {
            self.listOpenForEdit = lists.first { $0.id == id }
        }
        
        showEdit.toggle()
    }
}
