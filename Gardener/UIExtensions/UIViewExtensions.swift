//
//  UIViewExtensions.swift
//  Gärtnerarbeit
//
//  Created by Ehtisham Khalid on 08.05.21.
//

import Foundation
import UIKit

//MARK:- Animation Functions
extension UIView {
   
    func addShadow() {
//        self.layer.cornerRadius = 5.0
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 3
    }
    
}
