//
//  DetailsInfoViewModel.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 30/06/22.
//

import Foundation

class ItemDetailsViewModel: ObservableObject {    
    @Published var item: ListItemModel
    
    // MARK: - Lifecycle
    init(item: ListItemModel) {
        self.item = item
    }
}
