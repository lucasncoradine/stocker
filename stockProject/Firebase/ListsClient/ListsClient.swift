//
//  FBLists.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 26/05/22.
//

import Foundation
import Firebase

typealias FailureClosure = (_ message: String) -> Void

enum FailureMessage: String {
    case unauthenticated = "Usuário não autenticado"
}

class ListsClient {
    private let client: FirebaseClient = .init()
    private var listeners: [ListenerRegistration] = []
    
    // MARK: - Lifecycle
    deinit {
        stopListeners()
    }
    
    // MARK: - Private methods
    private func authenticatedUser(_ failure: FailureClosure) -> String? {
        guard let id = FirebaseClient.shared.userId else {
            failure(FailureMessage.unauthenticated.rawValue)
            return nil
        }
        
        return id
    }
    
    // MARK: - Methods
    func getUsers(failure: @escaping FailureClosure,
                  success: @escaping (_ data: [UserModel]) -> Void
    ) {
        client.getDocuments(as: UserModel.self, from: .users) { result in
            self.client.handleResult(result, success: success, failure: failure)
        }
    }
    
    func fetchLists(of userId: String,
                    failure: @escaping FailureClosure,
                    success: @escaping (_ data: [ListModel]) -> Void
    ) {
        let listener = client.listenToChanges(at: .lists(userId: userId), as: ListModel.self) { result in
            self.client.handleResult(result, success: success, failure: failure)
        }
        
        self.listeners.append(listener)
    }
    
    func fetchItems(of listId: String,
                    failure: @escaping FailureClosure,
                    success: @escaping (_ data: [ItemModel]) -> Void
    ) {
        guard let userId = authenticatedUser(failure) else { return }
        
        let listener = client.listenToChanges(at: .items(userId: userId, listId: listId), as: ItemModel.self) { result in
            self.client.handleResult(result, success: success, failure: failure)
        }
        
        self.listeners.append(listener)
    }
    
    /// Saves the list in database
    /// Creates a new object if the lists doesn't exists
    func saveList(with data: ListModel,
                  failure: @escaping FailureClosure
    ) {
        guard
            let id = data.id,
            let userId = authenticatedUser(failure)
        else { return }
        
        let collectionPath: FirebaseCollection = .lists(userId: userId)
        
        client.documentExists(documentId: id, at: collectionPath, failure: failure) { exists in
            if exists {
                self.client.updateDocument(documentId: id, with: data, from: collectionPath) { result in
                    self.client.handleResult(result, failure: failure)
                }
            } else {
                self.client.addDocument(data, to: collectionPath) { result in
                    self.client.handleResult(result, success: { _ in }, failure: failure)
                }
            }
        }
    }
    
    /// Saves the item in database
    /// Creates a new object if the item doesn't exists
    func saveItem(with data: ItemModel,
                  listId: String,
                  failure: @escaping FailureClosure
    ) {
        guard
            let id = data.id,
            let userId = authenticatedUser(failure)
        else { return }
        
        let collectionPath: FirebaseCollection = .items(userId: userId, listId: listId)
        
        client.documentExists(documentId: id, at: collectionPath, failure: failure) { exists in
            if exists {
                self.client.updateDocument(documentId: id, with: data, from: collectionPath) { result in
                    self.client.handleResult(result, failure: failure)
                }
            } else {
                self.client.addDocument(data, to: collectionPath) { result in
                    self.client.handleResult(result, success: { _ in }, failure: failure)
                }
            }
        }
    }
    
    func createList(with data: ListModel,
                    success: @escaping (_ data: ListModel) -> Void,
                    failure: @escaping FailureClosure) {
        guard let userId = authenticatedUser(failure) else { return }
        
        client.addDocument(data, to: .lists(userId: userId)) { result in
            self.client.handleResult(result, success: success, failure: failure)
        }
    }
    
    func deleteList(id: String,
                    failure: @escaping FailureClosure
    ) {
        guard let userId = authenticatedUser(failure) else { return }

        client.deleteDocument(id: id, from: .lists(userId: userId)) { result in
            self.client.handleResult(result, failure: failure)
        }
    }
    
    func deleteItem(id: String,
                    listId: String,
                    failure: @escaping FailureClosure
    ) {
        guard let userId = authenticatedUser(failure) else { return }

        client.deleteDocument(id: id, from: .items(userId: userId, listId: listId)) { result in
            self.client.handleResult(result, failure: failure)
        }
    }
    
    func stopListeners() {
        listeners.forEach { listener in
            listener.remove()
        }
    }
}
