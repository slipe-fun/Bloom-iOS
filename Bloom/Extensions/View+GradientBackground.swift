//
//  View+GradientBackground.swift
//  Bloom
//
//  Created by Аскольд on 07.07.2026.
//

import SwiftUI
import BlurSwiftUI

extension View {
    func topGradientBackground(color: Color) -> some View {
        self
            .background(
                ZStack {
                    VariableBlur(direction: .down)
                        .maximumBlurRadius(2.5)
                        .dimmingOvershoot(.relative(fraction: 1.3))
                        .passesTouchesThrough(true)
                        .dimmingTintColor(nil)

                    LinearGradient(
                        colors: [
                            color.opacity(0.8),
                            color.opacity(0.45),
                            color.opacity(0.0)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                }
            )
    }

    func bottomGradientBackground(color: Color, height: CGFloat? = nil) -> some View {
        self.background(alignment: .top) {
            LinearGradient(
                colors: [
                    color.opacity(0.8),
                    color.opacity(0.45),
                    color.opacity(0.0)
                ],
                startPoint: .bottom,
                endPoint: .top
            )
            .frame(height: height)
        }
    }
}
