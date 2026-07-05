//
//  WelcomeSuccessGlowView.swift
//  Bloom
//
//  Created by Аскольд on 25.06.2026.
//

import SwiftUI

struct WelcomeSuccessGlowView: View {
    @Binding var shown: Bool
    @State private var isRendered: Bool = false
    @State private var animationProgress: CGFloat = 0.0
    @State private var opacity: Double = 0.0
    @State private var blur: CGFloat = 10.0
    @State private var offset: CGFloat = 40.0
    
    @Environment(AppRouter.self) private var router
    
    let id: String = "dasdsf432"
    
    var body: some View {
        let color = avatarGradient(for: id)[0]
        
        ZStack {
            if isRendered {
                Theme.colors.background.opacity(0.75)
                    .ignoresSafeArea()
                    .opacity(opacity)
                
                AmbientUnderglowView(
                    tintColor: color,
                    particleColor: color,
                    animationProgress: animationProgress
                )
                
                VStack(alignment: .center, spacing: Theme.spacing.lg) {
                    AvatarView(size: .xl, square: false, image: "", id: id, name: "Dikiy Super")
                    
                    VStack(spacing: Theme.spacing.xs) {
                        Text("Welcome")
                            .font(Theme.font.body)
                            .lineSpacing(Theme.lineSpacing.md)
                            .foregroundStyle(Theme.colors.secondaryText)
                        
                        Text("Dikiy Dikiens!")
                            .font(Theme.font.title2)
                            .lineSpacing(Theme.lineSpacing.md)
                            .foregroundStyle(Theme.colors.text)
                    }
                    
                    Button {
                        router.isAuthenticated = true
                    } label: {
                        Text("Continue to chats")
                            .font(Theme.font.button)
                            .foregroundStyle(Theme.colors.white)
                    }
                    .buttonStyle(.plain)
                    .frame(height: 52)
                    .padding(.horizontal, Theme.spacing.xxxl)
                    .glassEffect(.clear.interactive().tint(color.opacity(0.5)))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .padding(.vertical, Theme.spacing.lg * 6.5)
                .opacity(opacity)
                .blur(radius: blur)
                .offset(y: offset)
            }
        }
        .allowsHitTesting(shown)
        .zIndex(1)
        .onChange(of: shown, initial: true) { _, newValue in
            handleVisibilityChange(newValue)
        }
    }
    
    private func handleVisibilityChange(_ isVisible: Bool) {
        if isVisible {
            isRendered = true
            
            withAnimation(.smooth) {
                blur = 0.0
                animationProgress = 1.0
                opacity = 1.0
                offset = 0.0
            }
        } else {
            withAnimation(.smooth) {
                blur = 10.0
                animationProgress = 0.0
                opacity = 0.0
                offset = 40.0
            }
            
            Task {
                try? await Task.sleep(for: .seconds(0.5))
                
                if !shown {
                    isRendered = false
                }
            }
        }
    }
}
