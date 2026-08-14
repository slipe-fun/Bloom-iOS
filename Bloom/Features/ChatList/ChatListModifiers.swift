//
//  ChatListModifiers.swift
//  Bloom
//
//  Created by Аскольд on 12.08.2026.
//

import SwiftUI
import BlurSwiftUI
import BlurUIKit

struct VariableBlurView: View {
    let height: CGFloat
    let color: Color?
    
    var body: some View {
        VariableBlur(direction: .down)
            .maximumBlurRadius(3.25)
            .dimmingOvershoot(.relative(fraction: 1.3))
            .passesTouchesThrough(true)
            .dimmingTintColor(color)
            .frame(height: height)
            .ignoresSafeArea(edges: .top)
    }
}

struct TopVariableBlurModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .top) {
                GeometryReader { geometry in
                    VariableBlurView(height: geometry.safeAreaInsets.top, color: Color(.systemBackground))
                }
            }
    }
}

struct BottomSafeAreaGradientModifier: ViewModifier {
    let height: CGFloat?
    
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
                        .frame(height: (height != nil) ? height : geometry.safeAreaInsets.bottom)
                    }
                    .frame(width: geometry.size.width, height: (height != nil) ? height : geometry.size.height, alignment: .bottom)
                    .ignoresSafeArea(edges: .bottom)
                    .allowsHitTesting(false)
                    .offset(y: (height != nil) ? 0 : geometry.safeAreaInsets.bottom)
                }
            }
    }
}

extension View {
    func topVariableBlur() -> some View {
        modifier(TopVariableBlurModifier())
    }

    func bottomSafeAreaGradient(height: CGFloat? = nil) -> some View {
        modifier(BottomSafeAreaGradientModifier(height: height))
    }
}
