//
//  ShareListViewModel.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 21/07/22.
//

import Foundation

class ShareListViewModel: ObservableObject {
    let deeplink: String
    
    init(listId: String) {
        self.deeplink = "stocker://?listId=\(listId)"
    }
}
