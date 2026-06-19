//
//  UIColor+Hex.swift
//  Bloom
//
//  Created by Аскольд on 19.06.2026.
//

import SwiftUI

extension UIColor {
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b, a: CGFloat
        switch hex.count {
        case 3:
            r = CGFloat((int >> 8) * 17) / 255
            g = CGFloat((int >> 4 & 0xF) * 17) / 255
            b = CGFloat((int & 0xF) * 17) / 255
            a = 1.0
        case 6:
            r = CGFloat(int >> 16) / 255
            g = CGFloat(int >> 8 & 0xFF) / 255
            b = CGFloat(int & 0xFF) / 255
            a = 1.0
        case 8:
            r = CGFloat(int >> 24) / 255
            g = CGFloat(int >> 16 & 0xFF) / 255
            b = CGFloat(int >> 8 & 0xFF) / 255
            a = CGFloat(int & 0xFF) / 255
        default:
            (r, g, b, a) = (1, 1, 1, 1)
        }
        self.init(red: r, green: g, blue: b, alpha: a)
    }
    
    static func dynamic(lightHex: String, darkHex: String) -> UIColor {
        UIColor { trait in
            trait.userInterfaceStyle == .dark ? UIColor(hex: darkHex) : UIColor(hex: lightHex)
        }
    }
}
