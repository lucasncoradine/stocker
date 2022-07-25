//
//  FBLists.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 26/05/22.
//

import Foundation
import FirebaseFirestore

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
    func get(id: String,
             failure: @escaping FailureClosure,
             success: @escaping (_ data: T) -> Void
    ) {
        client.getDocument(as: T.self, from: collection, id: id) { result in
            self.client.handleResult(result, success: success, failure: failure)
        }
    }
    
    func fetch(query: FirebaseQueryType? = nil,
               failure: @escaping FailureClosure,
               success: @escaping (_ data: [T]) -> Void
    ) {
        let listener = client.listenToChanges(at: collection, as: T.self, query: query) { result in
            self.client.handleResult(result, success: success, failure: failure)
        }
        
        self.listeners.append(listener)
    }
    
    func save(id: String,
              with data: T,
              failure: @escaping FailureClosure,
              canCreateNew: Bool = true,
              forceUpdate: Bool = false
    ) {
        client.documentExists(documentId: id, at: collection, failure: failure) { exists in
            if exists || forceUpdate {
                self.client.updateDocument(documentId: id, with: data, from: self.collection) { result in
                    self.client.handleResult(result, failure: failure)
                }
            } else if canCreateNew {
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
    
    func delete(ids: [String],
                failure: @escaping FailureClosure
    ) {
        client.deleteDocuments(ids: ids, from: collection) { result in
            self.client.handleResult(result, failure: failure)
        }
    }
    
    func updateValue(id: String, field: String, value: Any, failure: @escaping FailureClosure) {
        client.updateFieldValue(of: id, at: collection, field: field, with: value) { result in
            self.client.handleResult(result, failure: failure)
        }
    }
    
    func updateValue(ids: [String], field: String, value: Any, failure: @escaping FailureClosure) {
        ids.forEach { id in
            client.updateFieldValue(of: id, at: collection, field: field, with: value) { result in
                self.client.handleResult(result, failure: failure)
            }
        }
    }
    
    func addValuesToArrayField(id: String, field: String, values: [Any], failure: @escaping FailureClosure) {
        client.addValuesToArrayField(of: id, at: collection, field: field, with: values) { result in
            self.client.handleResult(result, failure: failure)
        }
    }
    
    func removeValuesFromArrayField(id: String, field: String, values: [Any], failure: @escaping FailureClosure) {
        client.removeValuesFromArrayField(of: id, at: collection, field: field, with: values) { result in
            self.client.handleResult(result, failure: failure)
        }
    }
    
    func stopListeners() {
        listeners.forEach { listener in
            listener.remove()
        }
    }
}
