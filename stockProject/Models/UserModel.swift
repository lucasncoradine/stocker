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

struct UserNameModel: Codable {
    var first: String
    var last: String
    
    enum CodingKeys: CodingKey {
        case first
        case last
    }
}

struct UserModel: ModelProtocol {
    @DocumentID var id: String? = UUID().uuidString
    var name: UserNameModel
    
    enum CodingKeys: CodingKey {
        case id
        case name
    }
}
