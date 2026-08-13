//
//  ChatListModifiers.swift
//  Bloom
//
//  Created by Аскольд on 12.08.2026.
//

import SwiftUI
import BlurSwiftUI
import BlurUIKit

struct TopVariableBlurModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .top) {
                GeometryReader { geometry in
                    VariableBlur(direction: .down)
                        .maximumBlurRadius(3.25)
                        .dimmingOvershoot(.relative(fraction: 1.3))
                        .passesTouchesThrough(true)
                        .frame(height: geometry.safeAreaInsets.top)
                        .ignoresSafeArea(edges: .top)
                }
            }
    }
}

struct BottomSafeAreaGradientModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .bottom) {
                GeometryReader { geometry in
                    ZStack(alignment: .bottom) {
                        LinearGradient(
                            colors: [
                                Color(.systemBackground).opacity(0.8),
                                Color(.systemBackground).opacity(0.45),
                                Color(.systemBackground).opacity(0)
                            ],
                            startPoint: .bottom,
                            endPoint: .top
                        )
                        .frame(height: geometry.safeAreaInsets.bottom)
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .bottom)
                    .ignoresSafeArea(edges: .bottom)
                    .allowsHitTesting(false)
                    .offset(y: geometry.safeAreaInsets.bottom)
                }
            }
    }
}

extension View {
    func topVariableBlur() -> some View {
        modifier(TopVariableBlurModifier())
    }

    func bottomSafeAreaGradient() -> some View {
        modifier(BottomSafeAreaGradientModifier())
    }
}
