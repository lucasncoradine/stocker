import Foundation

// MARK: - Response Models
enum ListType: String, Codable {
    case simple = "Simple List"
    case stock = "Stock"
}

struct ListModel: Codable {
    let name: String
    let type: ListType
    
    var isStock: Bool {
        self.type == .stock
    }
    
    enum CodingKeys: String, CodingKey {
        case type
        case name
    }
}

struct ListItem: Codable {
    let name: String
    let description: String?
    let amount: Int
    
    enum CodingKeys: String, CodingKey {
        case name
        case description
        case amount
    }
}
