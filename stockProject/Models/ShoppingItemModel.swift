//
//  ShoppingListModel.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 01/07/22.
//

import Foundation
import FirebaseFirestoreSwift

struct ShoppingItemModel: ModelProtocol {
    @DocumentID var id: String? = UUID().uuidString // Same ID as Item
    var name: String
    var checked: Bool = false
    var amount: Int = 1
    
    enum CodingKeys: CodingKey {
        case id
        case name
        case checked
        case amount
    }
}
