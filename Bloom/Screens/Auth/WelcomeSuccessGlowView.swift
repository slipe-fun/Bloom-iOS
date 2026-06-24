//
//  WelcomeSuccessGlowView.swift
//  Bloom
//
//  Created by Аскольд on 25.06.2026.
//

import SwiftUI

struct WelcomeSuccessGlowView: View {
    @Binding var shown: Bool
    
    @State private var revealProgress: CGFloat = 0.0
    
    var body: some View {
        if shown {
            ZStack {
                Theme.colors.background.opacity(0.75)
                    .ignoresSafeArea()
                    .opacity(shown ? 1.0 : 0.0)
                
                AmbientUnderglowView(tintColor: Theme.colors.red, particleColor: Theme.colors.red, animationProgress: shown ? 1.0 : 0.0)
                
                VStack {
                    Button("swag") {
                        self.shown = false
                    }
                    .buttonStyle(.plain)
                    .frame(height: 52)
                    .glassEffect(.regular.interactive().tint(Theme.colors.glassBackdrop))
                }
            }
            .zIndex(1)
            .animation(.normalSpring, value: shown)
        }
    }
}
