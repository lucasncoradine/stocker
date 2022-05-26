//
//  FBLists.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 26/05/22.
//

import Foundation

extension FirebaseClient {
    func getLists(success: @escaping (_ data: [ListModel]) -> Void,
                  failure: @escaping (_ message: String) -> Void
    ) {
        self.getDocuments(as: ListModel.self, from: .lists) { result in
            switch result {
            case .success(let data):
                success(data)
            case .failure(let error):
                failure(self.handleError(error))
            }
        }
    }
}
