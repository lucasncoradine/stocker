import Foundation
import FirebaseFirestoreSwift
import SwiftUI

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
        case .simple: return "list.bullet"
        case .stock: return "archivebox.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .simple: return Color(uiColor: .systemBlue)
        case .stock: return Color(uiColor: .systemGreen)
        }
    }
}

struct ListModel: Codable, Identifiable {
    @DocumentID var id: String? = UUID().uuidString
    var name: String
    var type: ListType
    var items: [ListItemModel]
    
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

struct ListItemModel: Codable, Identifiable, Equatable {
    var id: String
    var name: String
    var amount: Int
    var description: String
    
    init(id: String = UUID().uuidString,
         name: String = "",
         amount: Int = 0,
         description: String = ""
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
