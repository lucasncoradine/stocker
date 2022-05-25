//
//  AirtableExtension.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 23/05/22.
//

import Foundation

extension Request {
    private func filterByFormula(_ formula: String) -> Self {
        return self.query(name: "filterByFormula",
                   value: formula)
    }
    
    func filterBy(key: String, value: String) -> Self {
        self.filterByFormula("\(key)=\"\(value)\"")
    }
}
