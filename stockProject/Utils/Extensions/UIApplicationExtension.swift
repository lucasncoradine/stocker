//
//  UIApplicationExtension.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 17/07/22.
//

import UIKit

extension UIApplication {
    func dismissKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        self.sendAction(resign, to: nil, from: nil, for: nil)
    }
}
