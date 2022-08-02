//
//  StringExtension.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 02/08/22.
//

import Foundation

enum NormalizeOptions {
    case ignoreAccents
    case ignoreCase
}

extension String {
    func normalized(options: [NormalizeOptions]) -> String {
        var result: String = self
        
        options.forEach { option in
            switch option {
            case .ignoreAccents:
                result = result.folding(options: .diacriticInsensitive, locale: .current)
            case .ignoreCase:
                result = result.lowercased()
            }
        }
        
        return result
    }
    
    func normalizedForSort() -> String {
        return self.normalized(options: [.ignoreAccents, .ignoreCase])
    }
}
