import Foundation

enum ListType: String, Codable {
    case simple = "Simple List"
    case stock = "Stock"
}

struct ListData: Codable {
    let id: Int
    let type: ListType
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case type
        case name
    }
}
