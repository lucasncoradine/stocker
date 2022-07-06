//
//  FBLists.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 26/05/22.
//

import Foundation
import Firebase

typealias FailureClosure = (_ message: String) -> Void

class APIClient<T: Codable> {
    private let client: FirebaseClient = .init()
    private var listeners: [ListenerRegistration] = []
    private let collection: FirebaseCollection
    
    // MARK: - Lifecycle
    init(collection: FirebaseCollection) {
        self.collection = collection
    }
    
    deinit {
        stopListeners()
    }
    
    // MARK: - Methods
    func fetch(failure: @escaping FailureClosure,
               success: @escaping (_ data: [T]) -> Void
    ) {
        let listener = client.listenToChanges(at: collection, as: T.self) { result in
            self.client.handleResult(result, success: success, failure: failure)
        }
        
        self.listeners.append(listener)
    }
    
    func save(id: String,
              with data: T,
              failure: @escaping FailureClosure
    ) {
        client.documentExists(documentId: id, at: collection, failure: failure) { exists in
            if exists {
                self.client.updateDocument(documentId: id, with: data, from: self.collection) { result in
                    self.client.handleResult(result, failure: failure)
                }
            } else {
                self.client.addDocument(data, to: self.collection) { result in
                    self.client.handleResult(result, success: { _ in }, failure: failure)
                }
            }
        }
    }
    
    func create(with data: T,
                success: @escaping (_ data: T) -> Void,
                failure: @escaping FailureClosure
    ) {
        client.addDocument(data, to: collection) { result in
            self.client.handleResult(result, success: success, failure: failure)
        }
    }
    
    func delete(id: String,
                failure: @escaping FailureClosure
    ) {
        client.deleteDocument(id: id, from: collection) { result in
            self.client.handleResult(result, failure: failure)
        }
    }
    
    func stopListeners() {
        listeners.forEach { listener in
            listener.remove()
        }
    }
}
