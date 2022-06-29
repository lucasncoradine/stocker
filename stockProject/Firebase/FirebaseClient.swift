//
//  FirebaseClient.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 26/05/22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift


enum VoidResult {
    case success
    case failure(_: Error)
}

// MARK: - FirebaseCollection
enum FirebaseCollection: String {
    case lists = "lists"
}

// MARK: - FirebaseError
enum FirebaseError: Error {
    case noDocuments
}

// MARK: FirebaseClient
class FirebaseClient {
    private let database: Firestore
    
    // MARK: Lifecycle
    init() {
        self.database = Firestore.firestore()
    }
    
    /// Gets all documents from the desired collection
    /// - parameter type: The type of the documents which will be fetched.
    /// - parameter collection: The collection to get the documents from
    /// - parameter completion: A closure to handle the result of this request
    /// - returns: The result of the request
    func getDocuments<T: Decodable>(as type: T.Type,
                                    from collection: FirebaseCollection,
                                    completion: @escaping (_ result: Result<[T], Error>) -> Void
    ) {
        database.collection(collection.rawValue).getDocuments { (querySnapshot, error) in
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
        database.collection(collection.rawValue).document(id).getDocument(as: type) { queryResult in
            completion(queryResult)
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
            let documentReference = try database.collection(collection.rawValue).addDocument(from: data)
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
            try database.collection(collection.rawValue).document(documentId).setData(from: data)
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
        database.collection(collection.rawValue).document(id).delete() { error in
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
            let ref: DocumentReference = database.collection(collection.rawValue).document(id)
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
            return "Error decoding document: \(error.localizedDescription)"
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
}
