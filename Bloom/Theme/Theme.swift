//
//  Theme.swift
//  Bloom
//
//  Created by Аскольд on 19.06.2026.
//

import SwiftUI
import UIKit

struct Theme {
    struct spacing {
        static let xxs: CGFloat = 2
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 20
        static let xxl: CGFloat = 24
        static let xxxl: CGFloat = 28
        static let modal: CGFloat = 40
    }
    
    struct fontSize {
        static let xs: CGFloat = 12
        static let sm: CGFloat = 14
        static let md: CGFloat = 16
        static let lg: CGFloat = 18
        static let xl: CGFloat = 20
        static let xxl: CGFloat = 24
        static let xxxl: CGFloat = 32
        static let superSize: CGFloat = 64
    }
    
    struct radius {
        static let xxs: CGFloat = 8
        static let xs: CGFloat = 12
        static let sm: CGFloat = 16
        static let md: CGFloat = 20
        static let lg: CGFloat = 24
        static let xl: CGFloat = 26
        static let xxl: CGFloat = 32
        static let xxxl: CGFloat = 42
        static let full: CGFloat = 999
    }
    
    struct opacity {
        static let secondaryText: Double = 0.35
        static let contentText: Double = 0.5
        static let overlayText: Double = 0.75
    }
    
    struct borderWidth {
        static let md: CGFloat = 0.85
    }
    
    struct font {
        static func regular(size: CGFloat) -> Font { .custom("OpenRunde-Regular", size: size) }
        static func medium(size: CGFloat) -> Font { .custom("OpenRunde-Medium", size: size) }
        static func semibold(size: CGFloat) -> Font { .custom("OpenRunde-Semibold", size: size) }
        static func bold(size: CGFloat) -> Font { .custom("OpenRunde-Bold", size: size) }
    }
    
    struct colors {
        static let background = Color.dynamic(lightHex: "ffffff", darkHex: "000000")
        static let text = Color.dynamic(lightHex: "000000", darkHex: "ffffff")
        static let grayBackground = Color.dynamic(lightHex: "f1f1f4", darkHex: "000000ff")
        static let secondaryText = Color.dynamic(lightHex: "00000059", darkHex: "ffffff59")
        static let contentText = Color.dynamic(lightHex: "00000080", darkHex: "ffffff80")
        static let switcher = Color.dynamic(lightHex: "d7d7db", darkHex: "595959")
        static let overlayText = Color.dynamic(lightHex: "000000bf", darkHex: "ffffffbf")
        static let pressable = Color.dynamic(lightHex: "ffffff80", darkHex: "14141480")
        static let sectionForeground = Color.dynamic(lightHex: "ffffff", darkHex: "1b1b1d")
        static let foreground = Color.dynamic(lightHex: "f1f1f4", darkHex: "1b1b1d")
        static let foregroundTransparent = Color.dynamic(lightHex: "0000001c", darkHex: "ffffff1c")
        static let indicator = Color.dynamic(lightHex: "0000001a", darkHex: "ffffff26")
        static let border = Color.dynamic(lightHex: "0000000d", darkHex: "ffffff17")
        static let shadow = Color.dynamic(light: Color.black.opacity(0.06), dark: Color.clear)
        
        static let white = Color(uiColor: UIColor(hex: "ffffff"))
        static let black = Color(uiColor: UIColor(hex: "000000"))
        static let primary = Color(uiColor: UIColor(hex: "1A8CFF"))
        static let orange = Color(uiColor: UIColor(hex: "FF531B"))
        static let green = Color(uiColor: UIColor(hex: "1AFF7A"))
        static let pink = Color(uiColor: UIColor(hex: "FF1A45"))
        static let yellow = Color(uiColor: UIColor(hex: "FF901A"))
        static let cyan = Color(uiColor: UIColor(hex: "28A8E9"))
        static let purple = Color(uiColor: UIColor(hex: "A41AFF"))
        static let red = Color(uiColor: UIColor(hex: "F43025"))
        static let gray = Color(uiColor: UIColor(hex: "8C8C8C"))
        
        static let whiteBackdrop = white.opacity(0.5)
        static let blackBackdrop = black.opacity(0.5)
        static let primaryBackdrop = primary.opacity(0.5)
        static let orangeBackdrop = orange.opacity(0.5)
        static let greenBackdrop = green.opacity(0.5)
        static let pinkBackdrop = pink.opacity(0.5)
        static let yellowBackdrop = yellow.opacity(0.5)
        static let cyanBackdrop = cyan.opacity(0.5)
        static let purpleBackdrop = purple.opacity(0.5)
        static let redBackdrop = red.opacity(0.5)
        static let grayBackdrop = gray.opacity(0.5)
    }
}

private extension Color {
    static func dynamic(light: Color, dark: Color) -> Color {
        Color(uiColor: UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
        })
    }
    
    static func dynamic(lightHex: String, darkHex: String) -> Color {
        Color(uiColor: .dynamic(lightHex: lightHex, darkHex: darkHex))
    }
}

