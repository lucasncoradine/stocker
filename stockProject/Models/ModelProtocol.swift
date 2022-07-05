//
//  ModelProtocol.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 01/07/22.
//

import Foundation

protocol ModelProtocol: Codable, Identifiable {
    var id: String? { get set }
}
