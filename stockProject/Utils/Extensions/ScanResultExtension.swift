//
//  ScanResultExtension.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 25/07/22.
//

import Foundation
import CodeScanner

extension ScanResult {
    func url() -> URL? {
        return URL(string: self.string)
    }
}
