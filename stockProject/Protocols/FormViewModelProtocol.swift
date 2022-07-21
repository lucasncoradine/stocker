//
//  FormViewModelProtocol.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 18/07/22.
//

import Foundation

protocol FormViewModelProtocol: ViewModel {
    var validations: Validations { get set }
    
    func validateFields() -> Bool
}

protocol FormViewModelField {
    var description: String { get }
}
