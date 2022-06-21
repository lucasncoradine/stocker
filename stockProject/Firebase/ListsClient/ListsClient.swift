//
//  FBLists.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 26/05/22.
//

import Foundation
import Firebase

typealias FailureClosure = (_ message: String) -> Void

class ListsClient {
    private let client: FirebaseClient = .init()
    
    /// Gets all the Lists in database
    func getLists(failure: @escaping FailureClosure,
                  success: @escaping (_ data: [ListModel]) -> Void
    ) {
        client.getDocuments(as: ListModel.self, from: .lists) { result in
            self.client.handleResult(result, success: success, failure: failure)
        }
    }
    
    /// Create a new List  in database
    /// - parameter data: The data of the new list
    func createList(_ data: ListModel,
                    failure: @escaping FailureClosure,
                    success: @escaping (_ response: ListModel) -> Void
    ) {
        client.addDocument(data, to: .lists) { result in
            self.client.handleResult(result, success: success, failure: failure)
        }
    }
    
    /// Update a list in database
    /// - parameter data: The new data of the document
    func updateList(_ id: String,
                    with data: ListModel,
                    failure: @escaping FailureClosure
    ) {
        client.updateDocument(documentId: id, with: data, from: .lists) { result in
            self.client.handleResult(result, failure: failure)
        }
    }
    
    /// Deletes a set of Lists from the database
    /// - parameter id: The ID of the list to delete
    func deleteLists(_ ids: [String], failure: @escaping FailureClosure) {
        client.deleteDocuments(ids: ids, from: .lists) { result in
            self.client.handleResult(result, failure: failure)
        }
    }
    
    /// Deletes a List form the database
    /// - parameter id: The ID of the list to delete
    /// - parameter failure: An closure to handle the failure of the request
    func deleteList(_ id: String, failure: @escaping FailureClosure) {
        client.deleteDocument(id: id, from: .lists) { result in
            self.client.handleResult(result, failure: failure)
        }
    }
}
