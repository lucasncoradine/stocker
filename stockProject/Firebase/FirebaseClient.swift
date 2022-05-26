//
//  FirebaseClient.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 26/05/22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

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
    /// - parameter collection: The collection to get the documents from
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
    /// - parameter collection: The collection to get the document from
    /// - parameter id: The ID of the document you want
    func getDocument<T: Decodable>(as type: T.Type,
                                   from collection: FirebaseCollection,
                                   with id: String,
                                   completion: @escaping (_ result: Result<T, Error>) -> Void
    ){
        database.collection(collection.rawValue).document(id).getDocument(as: type) { queryResult in
            completion(queryResult)
        }
    }
    
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
}
