//
//  ModelProtocol.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 01/07/22.
//

import Foundation

protocol ModelProtocol: Codable, Identifiable, Equatable {
    var id: String? { get set }
    var name: String { get set }
}

// MARK: - ModelProtocol Collection Extension
enum SortType {
    case alphabetically
}

extension Collection where Element: ModelProtocol {
    func sorted(_ type: SortType) -> [Self.Element] {
        switch type {
        case .alphabetically:
            return self.sorted { $0.name.normalizedForSort() < $1.name.normalizedForSort() }
        }
    }
}
