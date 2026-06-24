//
//  Color+LottieColor.swift
//  Bloom
//
//  Created by Аскольд on 24.06.2026.
//

import SwiftUI
import Lottie

extension Color {
    var lottieColor: LottieColor {
        let uiColor = UIColor(self)
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        return LottieColor(r: Double(r), g: Double(g), b: Double(b), a: Double(a))
    }
}
