//
//  DepthModifiers.swift
//  Bloom
//
//  Created by Аскольд on 20.06.2026.
//

import SwiftUI

struct SettingsBehindModifier: AnimatableModifier {
    var progress: CGFloat
    var cornerRadius: CGFloat = 44
    
    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }

    func body(content: Content) -> some View {
        let scale: CGFloat = 0.925 + 0.075 * progress
        let opacity: CGFloat = 0.0 + 1.0 * progress
        let radius: CGFloat = (progress >= 0.999 || progress <= 0.001) ? 0 : cornerRadius

        content
            .ignoresSafeArea()
            .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
            .scaleEffect(scale, anchor: .center)
            .opacity(opacity)
    }
}

struct ChatsRootModifier: AnimatableModifier {
    var offset: CGFloat
    var isSettingsTransition: Bool
    var settingsProgress: CGFloat
    var standardProgress: CGFloat
    var cornerRadius: CGFloat = 44
    
    @Environment(\.colorScheme) var colorScheme
    
    var animatableData: AnimatablePair<CGFloat, AnimatablePair<CGFloat, CGFloat>> {
        get { AnimatablePair(offset, AnimatablePair(settingsProgress, standardProgress)) }
        set {
            offset = newValue.first
            settingsProgress = newValue.second.first
            standardProgress = newValue.second.second
        }
    }

    func body(content: Content) -> some View {
        let radius: CGFloat = (settingsProgress < 0.999 && settingsProgress > 0.001) ? cornerRadius : 0
        let brightness: Double = 0 + 0.1 * settingsProgress
        let backdropHitTesting: Bool = (standardProgress < 0.99 && standardProgress > 0.01)
        let backdropOpacity = max(0.0, 0.1 * standardProgress)

        content
            .ignoresSafeArea()
            .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
            .overlay(
                Color.black
                    .opacity(backdropOpacity)
                    .ignoresSafeArea()
                    .allowsHitTesting(backdropHitTesting)
            )
            .offset(x: offset)
            .brightness(colorScheme == .dark ? brightness : 0)
            .shadow(color: Color.black.opacity(offset < 0 ? 0.08 : 0), radius: 20, x: 0, y: 0)
    }
}

struct PushedScreenModifier: AnimatableModifier {
    var isTop: Bool
    var opacity: CGFloat
    var offset: CGFloat
    var progress: CGFloat
    var cornerRadius: CGFloat = 44
    
    var animatableData: AnimatablePair<CGFloat, AnimatablePair<CGFloat, CGFloat>> {
        get { AnimatablePair(offset, AnimatablePair(progress, opacity)) }
        set {
            offset = newValue.first
            progress = newValue.second.first
            opacity = newValue.second.second
        }
    }
    
    func body(content: Content) -> some View {
        let radius: CGFloat = (progress < 0.999 && progress > 0.001) ? cornerRadius : 0
        let shadowOpacity: CGFloat = (progress < 0.999) ? 0.08 : 0
        let backdropHitTesting: Bool = (progress < 0.99 && progress > 0.01)
        let backdropOpacity = isTop ? 0.0 : max(0.0, 0.1 * (1.0 - progress))
        
        content
            .ignoresSafeArea()
            .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
            .overlay(
                Color.black
                    .opacity(backdropOpacity)
                    .ignoresSafeArea()
                    .allowsHitTesting(backdropHitTesting)
            )
            .offset(x: offset)
            .opacity(opacity)
            .shadow(color: Color.black.opacity(shadowOpacity), radius: 20, x: 0, y: 0)
    }
}

struct PushTransitionModifier: AnimatableModifier {
    var progress: CGFloat
    var width: CGFloat
    var cornerRadius: CGFloat
    
    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }
    
    func body(content: Content) -> some View {
        let radius = (progress < 0.999 && progress > 0.001) ? cornerRadius : 0
        let shadowOpacity = (progress < 0.999 && progress > 0.001) ? 0.08 : 0
        let xOffset = width * (1.0 - progress)
        
        content
            .ignoresSafeArea()
            .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
            .shadow(color: Color.black.opacity(shadowOpacity), radius: 20, x: 0, y: 0)
            .offset(x: xOffset)
    }
}

extension AnyTransition {
    static func screenPush(width: CGFloat, cornerRadius: CGFloat) -> AnyTransition {
        .asymmetric(
            insertion: .modifier(
                active: PushTransitionModifier(progress: 0.0, width: width, cornerRadius: cornerRadius),
                identity: PushTransitionModifier(progress: 1.0, width: width, cornerRadius: cornerRadius)
            ),
            removal: .modifier(
                active: PushTransitionModifier(progress: 0.0, width: width, cornerRadius: cornerRadius),
                identity: PushTransitionModifier(progress: 1.0, width: width, cornerRadius: cornerRadius)
            )
        )
    }
}
