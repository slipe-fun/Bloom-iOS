//
//  DepthTransition.swift
//  Bloom
//
//  Created by Аскольд on 20.06.2026.
//

import SwiftUI

struct SettingsBehindRevealModifier: ViewModifier {
    let progress: CGFloat
    let cornerRadius: CGFloat
    let offset: CGFloat
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(0.75 + 0.25 * progress)
            .offset(x: offset)
            .mask(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .opacity(0.65 + 0.35 * progress)
                    .scaleEffect(0.75 + 0.25 * progress)
                    .offset(x: offset)
                    .ignoresSafeArea()
            )
    }
}

struct ChatsSlideLeftModifier: ViewModifier {
    let offset: CGFloat
    let cornerRadius: CGFloat
    
    func body(content: Content) -> some View {
        content
            .offset(x: offset)
            .mask(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .offset(x: offset)
                    .ignoresSafeArea()
            )
    }
}

extension View {
    func settingsBehindStyle(progress: CGFloat, cornerRadius: CGFloat, offset: CGFloat) -> some View {
        self.modifier(SettingsBehindRevealModifier(progress: progress, cornerRadius: cornerRadius, offset: offset))
    }
    
    func chatsSlideLeftStyle(offset: CGFloat, cornerRadius: CGFloat) -> some View {
        self.modifier(ChatsSlideLeftModifier(offset: offset, cornerRadius: cornerRadius))
    }
}
