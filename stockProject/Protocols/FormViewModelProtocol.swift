//
//  FormViewModelProtocol.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 18/07/22.
//

import Foundation

protocol FormViewModel: ObservableObject {
    var validations: Validations { get set }
    
    func requestFailed(_ message: String)
    func validateFields() -> Bool
}
