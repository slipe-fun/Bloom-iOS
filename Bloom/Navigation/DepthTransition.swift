//
//  DepthTransition.swift
//  Bloom
//
//  Created by Аскольд on 20.06.2026.
//

import SwiftUI

struct SettingsBehindRevealModifier: ViewModifier {
    let progress: CGFloat
    
    func body(content: Content) -> some View {
        let currentRadius = 44.0
        
        content
            .scaleEffect(0.85 + 0.15 * progress)
            .blur(radius: 12 * (1.0 - progress))
            .opacity(progress)
            .cornerRadius(currentRadius)
            .ignoresSafeArea()
    }
}

struct ChatsSlideLeftModifier: ViewModifier {
    let offset: CGFloat
    let progress: CGFloat
    
    func body(content: Content) -> some View {
        let currentRadius = 44.0
        
        content
            .offset(x: offset)
            .cornerRadius(currentRadius)
            .ignoresSafeArea()
    }
}

extension View {
    func settingsBehindStyle(progress: CGFloat) -> some View {
        self.modifier(SettingsBehindRevealModifier(progress: progress))
    }
    
    func chatsSlideLeftStyle(offset: CGFloat, progress: CGFloat) -> some View {
        self.modifier(ChatsSlideLeftModifier(offset: offset, progress: progress))
    }
}
