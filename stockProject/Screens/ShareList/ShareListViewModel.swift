//
//  ShareListViewModel.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 21/07/22.
//

import Foundation

class ShareListViewModel: ObservableObject {
    let deeplink: Deeplink
    
    init(listId: String) {
        self.deeplink = Deeplink(path: .shareList, params: ["listId": listId])
    }
}
