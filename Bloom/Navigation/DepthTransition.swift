//
//  DepthTransition.swift
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
        let scale = 0.9 + 0.1 * progress
        let opacity = 0.5 + 0.5 * progress
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
    var progress: CGFloat
    var cornerRadius: CGFloat = 44
    
    @Environment(\.colorScheme) var colorScheme
    
    var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get { AnimatablePair(offset, progress) }
        set {
            offset = newValue.first
            progress = newValue.second
        }
    }

    func body(content: Content) -> some View {
        let radius: CGFloat = (progress < 0.999 && progress > 0.001) ? cornerRadius : 0
        let brightness: Double = 0 + 0.1 * progress

        content
            .ignoresSafeArea()
            .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
            .offset(x: offset)
            .brightness(colorScheme == .dark ? brightness : 0)
            .shadow(color: Theme.colors.black.opacity(offset < 0 ? 0.08 : 0), radius: 20, x: 0, y: 0)
    }
}

struct PushedScreenModifier: AnimatableModifier {
    var offset: CGFloat
    var progress: CGFloat
    var cornerRadius: CGFloat = 44
    
    var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get { AnimatablePair(offset, progress) }
        set {
            offset = newValue.first
            progress = newValue.second
        }
    }
    
    func body(content: Content) -> some View {
        let radius: CGFloat = (progress < 0.999 && progress > 0.001) ? cornerRadius : 0
        
        content
            .ignoresSafeArea()
            .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
            .offset(x: offset)
            .shadow(color: .black.opacity(offset < 0 ? 0.7 : 0), radius: 10, x: -5, y: 0)
    }
}

extension AnyTransition {
    static var screenWidth: CGFloat {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return 375 }
        return windowScene.screen.bounds.width
    }
    
    static var chatsToSettingsPush: AnyTransition {
        .asymmetric(
            insertion: .modifier(
                active: SettingsBehindModifier(progress: 0),
                identity: SettingsBehindModifier(progress: 1)
            ),
            removal: .modifier(
                active: ChatsRootModifier(offset: -screenWidth, isSettingsTransition: true, progress: 1),
                identity: ChatsRootModifier(offset: 0, isSettingsTransition: true, progress: 0)
            )
        )
    }
    
    static var chatsToSettingsPop: AnyTransition {
        .asymmetric(
            insertion: .modifier(
                active: ChatsRootModifier(offset: -screenWidth, isSettingsTransition: true, progress: 1),
                identity: ChatsRootModifier(offset: 0, isSettingsTransition: true, progress: 0)
            ),
            removal: .modifier(
                active: SettingsBehindModifier(progress: 0),
                identity: SettingsBehindModifier(progress: 1)
            )
        )
    }
    
    static var screenPush: AnyTransition {
        .asymmetric(
            insertion: .modifier(
                active: PushedScreenModifier(offset: screenWidth, progress: 0),
                identity: PushedScreenModifier(offset: 0, progress: 1)
            ),
            removal: .modifier(
                active: PushedScreenModifier(offset: screenWidth, progress: 0),
                identity: PushedScreenModifier(offset: 0, progress: 1)
            )
        )
    }
}
