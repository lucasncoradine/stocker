//
//  ShareListViewModel.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 21/07/22.
//

import Foundation

class ShareListViewModel: ObservableObject {
    let deeplink: Deeplink
    let listName: String
    
    init(listId: String, listName: String) {
        self.listName = listName
        self.deeplink = Deeplink(path: .invite, params: ["listId": listId])
    }
}
