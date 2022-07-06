//
//  ListsClient.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 06/07/22.
//

import Foundation

class ListClient: APIClient {
    func fetchLists(failure: @escaping FailureClosure, success: @escaping ([ListModel]) -> Void) {
        self.fetch(failure: failure, success: success)
    }
    
    func saveList(id: String, with data: ListModel, failure: @escaping FailureClosure) {
        self.save(id: id, with: data, failure: failure)
    }
    
    func createList(data: ListModel, success: @escaping (ListModel) -> Void, failure: @escaping FailureClosure) {
        self.create(with: data, success: success, failure: failure)
    }
    
    func deleteList(id: String, failure: @escaping FailureClosure) {
        self.delete(id: id, failure: failure)
    }
}
