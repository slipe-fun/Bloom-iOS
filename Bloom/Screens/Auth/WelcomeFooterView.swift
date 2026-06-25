//
//  WelcomeFooterView.swift
//  Bloom
//
//  Created by Аскольд on 24.06.2026.
//

import SwiftUI

struct WelcomeFooterView: View {
    @Environment(AppRouter.self) private var router
    
    @Binding var shown: Bool
    
    var body: some View {
        GlassEffectContainer{
            VStack(alignment: .trailing, spacing: Theme.spacing.md) {
                Button {
                    Task {
                        let success = await BiometricAuthManager.authenticate()
                        if success {
                            try? await Task.sleep(for: .seconds(2))
                            self.shown = true
                        }
                    }
                } label: {
                    HStack(spacing: Theme.spacing.sm) {
                        CustomLottieView(
                            source: "faceId",
                            loop: true,
                            autoPlay: true,
                            size: 26,
                            color: Theme.colors.white
                        )
                        Text("Continue with FaceID")
                            .font(Theme.font.semibold(size: Theme.fontSize.lg))
                            .foregroundStyle(Theme.colors.white)
                    }
                }
                .buttonStyle(.plain)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .glassEffect(.regular.interactive().tint(Theme.colors.primary))
                
                Text("By continuing you agree to the **[Terms of Service](custom-scheme//terms)**")
                    .font(Theme.font.medium(size: Theme.fontSize.md))
                    .foregroundStyle(Theme.colors.secondaryText)
                    .tint(Theme.colors.primary)
                    .multilineTextAlignment(.center)
                    .environment(\.openURL, OpenURLAction { url in
                        if url.scheme == "custom-scheme" {
                            print("Terms opened!")
                            return .handled
                        }
                        return .systemAction
                    })
            }
            .padding(.horizontal, Theme.spacing.xxxl + 8)
            .padding(.bottom, Theme.spacing.xxxl + 8)
        }
    }
}
