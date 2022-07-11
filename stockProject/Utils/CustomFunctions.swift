//
//  BoolExtension.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 07/07/22.
//

import Foundation

func doAfter(_ interval: TimeInterval, closure: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
        closure()
    }
}

func doAfter(_ interval: TimeInterval, work: DispatchWorkItem) {
    DispatchQueue.main.asyncAfter(deadline: .now() + interval, execute: work)
}
