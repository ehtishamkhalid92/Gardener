//
//  UIButtonExtensions.swift
//  Gärtnerarbeit
//
//  Created by Ehtisham Khalid on 08.05.21.
//

import Foundation
import UIKit

extension UIButton{
    func addButtonShadow() {
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: 1, height: 2)
        layer.shadowRadius = 3.0
        layer.shadowOpacity = 1.0
        layer.shadowColor = #colorLiteral(red: 0.7529411765, green: 0.7529411765, blue: 0.7529411765, alpha: 1)
    }
}
