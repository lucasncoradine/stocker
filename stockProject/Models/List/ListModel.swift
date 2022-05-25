import Foundation

enum ListType: String, Codable {
    case simple = "simple"
    case stock = "stock"
}

struct ListModel: Codable, Identifiable {
    let id: UUID
    let name: String
    let type: ListType
    let items: [ListItemModel]?
    
    init(id: UUID = UUID(),
         name: String,
         type: ListType,
         items: [ListItemModel] = []
    ) {
        self.id = id
        self.name = name
        self.type = type
        self.items = items
    }
    
    var isStock: Bool {
        self.type == .stock
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case type
        case name
        case items
    }
}

struct ListItemModel: Codable, Identifiable {
    let id: UUID
    let name: String
    let amount: Int
    let description: String?
    
    init(id: UUID = UUID(),
         name: String,
         amount: Int,
         description: String? = nil
    ) {
        self.id = id
        self.name = name
        self.amount = amount
        self.description = description
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case amount
        case description
    }
}
