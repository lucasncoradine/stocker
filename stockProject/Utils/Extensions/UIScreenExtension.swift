//
//  UIScreenExtension.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 26/07/22.
//

import Foundation
import UIKit

extension UIScreen {
    var centerX: CGFloat {
        self.bounds.width / 2
    }
    
    var centerY: CGFloat {
        self.bounds.height / 2
    }
}
