//
//  ItemModel.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 01/07/22.
//

import Foundation
import FirebaseFirestoreSwift

struct ItemModel: ModelProtocol {
    @DocumentID var id: String? = UUID().uuidString
    var name: String
    var description: String
    var amount: Int
    var inShoppingList: Bool = false
    
    enum CodingKeys: CodingKey {
        case id
        case name
        case description
        case amount
        case inShoppingList
    }
}
