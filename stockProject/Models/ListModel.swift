//
//  ListModel.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 01/07/22.
//

import Foundation
import FirebaseFirestoreSwift

struct ListModel: ModelProtocol {
    @DocumentID var id: String? = UUID().uuidString
    var name: String
    var sharedWith: [String]? = [] // User IDs
    
    enum CodingKeys: CodingKey {
        case id
        case name
        case sharedWith
    }
}
