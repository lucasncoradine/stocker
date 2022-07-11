//
//  ListSelection.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 08/07/22.
//

import Foundation
import SwiftUI

typealias Selection<T: Hashable> = Set<T>

extension Selection {
    mutating func toggle(_ item: Element) {
        guard self.contains(item)
        else {
            self.insert(item)
            return
        }
        
        self.remove(item)
    }
    
    mutating func toggleMultiple(_ items: [Element]) {
        items.forEach { item in
            self.toggle(item)
        }
    }
    
    func asArray<T>() -> [T] where Element == T? {
        return self.compactMap { $0 }
    }
}
