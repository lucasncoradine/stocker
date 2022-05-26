//
//  FBLists.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 26/05/22.
//

import Foundation

class FBLists {
    private let client: FirebaseClient
    
    // MARK: - Lifecycle
    init() {
        self.client = FirebaseClient()
    }
    
    func getLists(
        success: @escaping (_ data: [ListModel]) -> Void,
        failure: @escaping (_ message: String) -> Void
    ) {
        let result = client.getDocuments(as: ListModel.self, from: .lists)
        switch result {
        case .success(let data):
            success(data)
        case .failure(let error):
            failure(error.localizedDescription)
        }
    }
}
