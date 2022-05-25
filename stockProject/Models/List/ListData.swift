// MARK: - Mapped Objects
struct ListData: Identifiable {
    let id: String
    let name: String
    let type: ListType
    
    var isStock: Bool {
        self.type == .stock
    }
    
    init(recordId: String = "", label: String, type: ListType) {
        self.id = recordId
        self.name = label
        self.type = type
    }
}

struct DetailsListData: Identifiable {
    let id: String
    let name: String
    let amount: Int
    
    init(recordId: String = "", label: String, amount: Int) {
        self.id = recordId
        self.name = label
        self.amount = amount
    }
}
