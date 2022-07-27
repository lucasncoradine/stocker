//
//  UserModel.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 01/07/22.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseAuth

typealias FirebaseUser = User

struct UserModel: ModelProtocol {
    @DocumentID var id: String? = UUID().uuidString
    var name: String
    
    enum CodingKeys: CodingKey {
        case id
        case name
    }
}
