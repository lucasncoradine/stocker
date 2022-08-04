//
//  ItemModel.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 01/07/22.
//

import Foundation
import FirebaseFirestoreSwift
import SwiftUI

// MARK: - ItemAlertType
enum ItemAlertType {
    case expired
    case needToBuy
    case none
    
    var color: Color {
        switch self {
        case .expired: return .red
        case .needToBuy: return .orange
        case .none: return Color(.label)
        }
    }
    
    var icon: String {
        switch self {
        case .expired: return "calendar.badge.exclamationmark"
        case .needToBuy: return "exclamationmark.circle"
        case .none: return ""
        }
    }
}

// MARK: ItemModel
struct ItemModel: ModelProtocol, Hashable {
    @DocumentID var id: String? = UUID().uuidString
    var name: String
    var description: String = ""
    var amount: Int
    var expirationDate: Date? = nil
    
    var isExpired: Bool {
        guard let expirationDate = expirationDate else {
            return false
        }

        return expirationDate < Date.now
    }
    
    var needToBuy: Bool {
        return self.amount == 0
    }
    
    enum CodingKeys: CodingKey {
        case id
        case name
        case description
        case amount
        case expirationDate
    }
}

extension ItemModel {
    var alertType: ItemAlertType {
        if self.isExpired {
            return .expired
        }
        
        if self.needToBuy {
            return .needToBuy
        }
        
        return .none
    }
}
