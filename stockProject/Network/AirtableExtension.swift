//
//  AirtableExtension.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 23/05/22.
//

import Foundation

extension Request {
    func filterByFormula(_ formula: String) -> Self {
        self.query(name: "filterByFormula", value: formula)
    }
    
    func filterById(_ id: Int) -> Self {
        self.filterByFormula("id=\(id)")
    }
}
