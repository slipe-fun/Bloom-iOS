//
//  ScaleButtonStyle.swift
//  Bloom
//
//  Created by Аскольд on 19.06.2026.
//

import SwiftUI

struct ScaleButtonStyle: ButtonStyle {
    let icon: Bool = true
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? (icon ? 1.2 : 1.15) : 1.0)
            .animation(.springy, value: configuration.isPressed)
    }
}
