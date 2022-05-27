import Foundation
import FirebaseFirestoreSwift

enum ListType: String, Codable, CaseIterable, Identifiable {
    case simple = "simple"
    case stock = "stock"
    var id: Self { self }
    
    var label: String {
        switch self {
        case .simple: return "Simples"
        case .stock: return "Estoque"
        }
    }
    
    var icon: String {
        switch self {
        case .simple: return "ListIcon"
        case .stock: return "StockIcon"
        }
    }
}

struct ListModel: Codable, Identifiable {
    @DocumentID var id: String? = UUID().uuidString
    let name: String
    let type: ListType
    let items: [ListItemModel]?
    
    init(name: String,
         type: ListType,
         items: [ListItemModel] = []
    ) {
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
    let id: Int
    let name: String
    let amount: Int
    let description: String?
    
    init(id: Int,
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
