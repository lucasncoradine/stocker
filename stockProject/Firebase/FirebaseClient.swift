//
//  FirebaseClient.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 26/05/22.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

typealias FailureClosure = (_ message: String) -> Void

enum VoidResult {
    case success
    case failure(_: Error)
}

// MARK: - FirebaseCollection
enum FirebaseCollection {
    case users
    case lists
    case items(listId: String)
    case shoppingList(listId: String)
    
    var path: String {
        let userId = AuthManager.shared.user?.uid ?? "nil"
        
        switch self {
        case .users:
            return "users"
        case .lists:
            return "users/\(userId)/lists"
        case .items(let listId):
            return "users/\(userId)/lists/\(listId)/items"
        case .shoppingList(let listId):
            return "users/\(userId)/lists/\(listId)/shoppingList"
        }
    }
}

// MARK: - FirebaseError
enum FirebaseError: Error {
    case noDocuments
    case noUser
}

// MARK: - FirebaseClient
class FirebaseClient {
    private let database: Firestore
    
    // MARK: Lifecycle
    init() {
        self.database = Firestore.firestore()
    }
    
    // MARK: - Methods
    
    /// Gets all documents from the desired collection
    /// - parameter type: The type of the documents which will be fetched.
    /// - parameter collection: The collection to get the documents from
    /// - parameter completion: A closure to handle the result of this request
    /// - returns: The result of the request
    func getDocuments<T: Decodable>(as type: T.Type,
                                    from collection: FirebaseCollection,
                                    query: FirebaseQueryType? = nil,
                                    completion: @escaping (_ result: Result<[T], Error>) -> Void
    ) {
        database.collection(collection.path).makeQuery(query).getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                completion(.failure(FirebaseError.noDocuments))
                return
            }
            
            do {
                let result = try documents.compactMap { queryDocumentSnapshot -> T? in
                    try queryDocumentSnapshot.data(as: type)
                }
                
                completion(.success(result))
            } catch let mappingError {
                completion(.failure(mappingError))
            }
        }
    }
    
    /// Gets a single document from the desired collection
    /// - parameter as: The tyoe of the document which will be fetched.
    /// - parameter collection: The collection to get the document from
    /// - parameter id: The ID of the document you want
    /// - parameter completion: A closure to handle the result of this request
    func getDocument<T: Decodable>(as type: T.Type,
                                   from collection: FirebaseCollection,
                                   id: String,
                                   completion: @escaping (_ result: Result<T, Error>) -> Void
    ){
        database.collection(collection.path).document(id).getDocument { (documentSnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let document = documentSnapshot else {
                completion(.failure(FirebaseError.noDocuments))
                return
            }
            
            do {
                let result = try document.data(as: type)
                
                completion(.success(result))
            } catch let mappingError {
                completion(.failure(mappingError))
            }
        }
    }
    
    /// Check if document existis in database
    /// - parameter documentId: The ID of the document you want
    /// - parameter collection: The collection to get the document from
    /// - parameter completion: A closure to handle the result of this request
    func documentExists(documentId: String,
                        at collection: FirebaseCollection,
                        failure: @escaping (_ message: String) -> Void,
                        success: @escaping (_ exists: Bool) -> Void
    ) {
        database.collection(collection.path).document(documentId).getDocument { documentSnapshot, error in
            if let error = error {
                failure(self.handleError(error))
            }
            
            success(documentSnapshot?.exists ?? false)
        }
    }
    
    /// Adds a document to a specific collection.
    /// - parameter data: The data of the new document
    /// - parameter to: The collection which the document will be added to
    /// - parameter completion: A closure to handle the result of this request.
    func addDocument<T: Codable>(_ data: T,
                                 to collection: FirebaseCollection,
                                 completion: @escaping (_ result: Result<T, Error>) -> Void
    ) {
        do {
            let documentReference = try database.collection(collection.path).addDocument(from: data)
            documentReference.getDocument(as: T.self) { result in
                completion(result)
            }
        } catch let addingError {
            completion(.failure(addingError))
        }
    }
    
    /// Uptade a document from a specific collection
    /// - parameter documentId: The id of the document to update
    /// - parameter with: The new data of the document
    /// - parameter from: The collection of the document
    /// - parameter completion: A closure to handle the result of the request.
    func updateDocument<T: Codable>(documentId: String,
                                    with data: T,
                                    from collection: FirebaseCollection,
                                    completion: @escaping (_ result: VoidResult) -> Void
    ) {
        do {
            try database.collection(collection.path).document(documentId).setData(from: data)
            completion(.success)
        } catch let error {
            completion(.failure(error))
        }
    }
    
    /// Delete a document from the  collection
    /// - parameter id: The ID of the document to delete
    /// - parameter collection: The colection which the document will be deleted from
    /// - parameter completion: A closure to handle the result of this request
    func deleteDocument(id: String,
                        from collection: FirebaseCollection,
                        completion: @escaping (_ result: VoidResult) -> Void
    ) {
        database.collection(collection.path).document(id).delete() { error in
            guard let error = error else {
                completion(.success)
                return
            }
            
            completion(.failure(error))
        }
    }
    
    /// Deletes multiple documents from the collection
    /// - parameter ids: A set of IDs to delete
    /// - parameter collection: The collection which the documents will be deleted from
    /// - parameter completion: A closure to handle the result of this request
    func deleteDocuments(ids: [String],
                         from collection: FirebaseCollection,
                         completion: @escaping (_ result: VoidResult) -> Void
    ) {
        let batch = database.batch()
        
        ids.forEach { id in
            let ref: DocumentReference = database.collection(collection.path).document(id)
            batch.deleteDocument(ref)
        }
        
        batch.commit { error in
            guard let error = error else {
                completion(.success)
                return
            }
            
            completion(.failure(error))
        }
    }
    
    /// Listen and returns all changes at the informed collection
    /// - parameter collection: Collection to listen to
    /// - parameter type: The type of the documents which will be fetched.
    /// - parameter completion: A closure to handle the result of this request
    func listenToChanges<T: Decodable>(at collection: FirebaseCollection,
                                       as type: T.Type,
                                       query: FirebaseQueryType? = nil,
                                       completion: @escaping (_ result: Result<[T], Error>) -> Void
    ) -> ListenerRegistration {
        return database.collection(collection.path).makeQuery(query).addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                completion(.failure(FirebaseError.noDocuments))
                return
            }
            
            do {
                let result = try documents.compactMap { queryDocumentSnapshot -> T? in
                    try queryDocumentSnapshot.data(as: type)
                }
                
                completion(.success(result))
            } catch let mappingError {
                completion(.failure(mappingError))
            }
        }
    }
    
    /// Stops the listener
    /// - parameter listener: The listener to remove
    func removeListener(_ listener: ListenerRegistration) {
        listener.remove()
    }
    
    /// Updates the field’s current value by the given value.
    /// - parameter of documentId: The ID of the document to update
    /// - parameter at collection: The collection of the document
    /// - parameter field: The Field to update
    /// - parameter with value: The new value of the field
    /// - parameter completion: A closure to handle the result of the request
    func updateFieldValue(of documentId: String,
                          at collection: FirebaseCollection,
                          field: String,
                          with value: Any,
                          completion: @escaping (_ result: VoidResult) -> Void) {
        database.collection(collection.path).document(documentId).updateData([field: value]) { error in
            guard let error = error
            else {
                completion(.success)
                return
            }
            
            completion(.failure(error))
        }
    }
    
    // MARK: - Helper functions
    /// Handles the error and returns its description
    /// - parameter error: The error to handle
    func handleError(_ error: Error) -> String {
        switch error {
        case DecodingError.typeMismatch(_, let context):
            return "\(error.localizedDescription): \(context.debugDescription)"
        case DecodingError.valueNotFound(_, let context):
            return "\(error.localizedDescription): \(context.debugDescription)"
        case DecodingError.keyNotFound(_, let context):
            return "\(error.localizedDescription): \(context.debugDescription)"
        case DecodingError.dataCorrupted(let key):
            return "\(error.localizedDescription): \(key)"
        default:
            return "\(error.localizedDescription)"
        }
    }
    
    /// Handles the result of a Firebase request.
    /// - parameter result: The result of the request
    /// - parameter success: A closure to handle if the request succeeded
    /// - parameter failure  A closure to handle if the request failed
    func handleResult<T: Decodable>(_ result: Result<T, Error>,
                                    success: @escaping (_ data: T) -> Void,
                                    failure: @escaping (_ message: String) -> Void
    ) {
        switch result {
        case .success(let data):
            success(data)
        case .failure(let error):
            failure(self.handleError(error))
        }
    }
    
    /// Handles the result of a Firebase request.
    /// - parameter result: The result of the request
    /// - parameter success: A closure to handle if the request succeeded
    /// - parameter failure  A closure to handle if the request failed
    func handleResult(_ result: VoidResult,
                      success: @escaping (() -> Void) = {},
                      failure: @escaping (_ message: String) -> Void
    ) {
        switch result {
        case .success:
            success()
        case .failure(let error):
            failure(self.handleError(error))
        }
    }
    
    /// Handles the result of a Firebase request.
    /// - parameter result: The result of the request
    /// - parameter success: A closure to handle if the request succeeded
    /// - parameter failure  A closure to handle if the request failed
    func handleResult(_ result: Result<FirebaseUser, Error>,
                      success: @escaping (_ user: FirebaseUser) -> Void,
                      failure: @escaping (_ message: String) -> Void
    ) {
        switch result {
        case .success(let user):
            success(user)
        case .failure(let error):
            failure(self.handleError(error))
        }
    }
}


// MARK: - CollectionReference Extension

enum FirebaseQueryType {
    case isEqual(field: String, to: Any)
}

extension CollectionReference {
    func makeQuery(_ type: FirebaseQueryType? = nil) -> Query {
        if let type = type {
            switch type {
            case .isEqual(let field, let value):
                return self.whereField(field, isEqualTo: value)
            }
        }
        
        return self
    }
}
