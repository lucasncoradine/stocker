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
    private var listeners: [ListenerRegistration] = []
    private var userId: String?
    
    
    // MARK: - Lifecycle
    init(userId: String? = nil) {
        self.userId = userId
    }
    
    deinit {
        stopListeners()
    }
    
    // MARK: - Methods
    func setUserId(_ id: String) {
        self.userId = id
    }
    
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
        guard let userId = userId else { return }
        
        let listener = client.listenToChanges(at: .items(userId: userId, listId: listId), as: ItemModel.self) { result in
            self.client.handleResult(result, success: success, failure: failure)
        }
        
        self.listeners.append(listener)
    }
    
    func deleteList(id: String,
                    failure: @escaping FailureClosure
    ) {
        guard let userId = userId else { return }
        
        
        client.deleteDocument(id: id, from: .lists(userId: userId)) { result in
            self.client.handleResult(result, failure: failure)
        }
    }
    
    func stopListeners() {
        listeners.forEach { listener in
            listener.remove()
        }
    }
}
