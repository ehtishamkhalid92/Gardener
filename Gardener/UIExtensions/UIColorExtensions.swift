//
//  UIColorExtensions.swift
//  Gärtnerarbeit
//
//  Created by Ehtisham Khalid on 08.05.21.
//

import Foundation
import UIKit

//MARK:-  Custom Color
// Green color Hex code

let mediumGreen = UIColor(hexString:"#3CB371")
let LighterGreen = UIColor(hexString:"#e3fbe3")
let limeGreen = UIColor(hexString:"#EAFAF1")
let dimgray = UIColor(hexString:"#696969")
let silver = UIColor(hexString:"#C0C0C0")
let SafetyYellow = UIColor(hexString:"#eed202")
let RedOrange = UIColor(hexString:"#ff5349")

extension UIColor {
    
    // TODO:-  Change the color by adding hexadecimal code
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
