//
//  BoolExtension.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 07/07/22.
//

import Foundation

func doAfter(_ interval: TimeInterval, closure: @escaping () -> Void) {
    Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { _ in
        closure()
    }
}
