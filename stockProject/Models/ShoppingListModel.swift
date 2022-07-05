//
//  ShoppingListModel.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 01/07/22.
//

import Foundation
import FirebaseFirestoreSwift

struct ShoppingListModel: ModelProtocol {
    @DocumentID var id: String? = UUID().uuidString
    var name: String
    var checked: Bool = false
    
    enum CodingKeys: CodingKey {
        case id
        case name
        case checked
    }
}