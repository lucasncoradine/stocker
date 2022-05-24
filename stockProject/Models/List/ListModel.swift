import Foundation

enum ListType: String, Codable {
    case simple = "Simple List"
    case stock = "Stock"
}

struct ListData: Codable {
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
