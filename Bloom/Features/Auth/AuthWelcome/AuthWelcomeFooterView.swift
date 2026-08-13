//
//  AuthWelcomeFooterView.swift
//  Bloom
//
//  Created by Аскольд on 14.08.2026.
//

import SwiftUI

struct AuthWelcomeFooterView: View {
    let appeared: Bool
    
    var body: some View {
        VStack(spacing: 16) {

            NavigationLink(value: AuthRoute.success) {
                Label(
                    "Continue with iCloud",
                    systemImage: "icloud.fill"
                )
                .font(
                    .system(
                        .headline,
                        design: .rounded,
                        weight: .semibold
                    )
                )
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
            }
            .buttonStyle(.plain)
            .glassEffect(
                .regular
                    .interactive()
                    .tint(Theme.colors.primary)
            )
            .opacity(appeared ? 1 : 0)
            .offset(y: appeared ? 0 : 16)
            .blur(radius: appeared ? 0 : 8)
            .animation(
                .smooth(duration: 0.75).delay(0.24),
                value: appeared
            )

            NavigationLink(value: AuthRoute.mnemonic) {
                Label(
                    "Continue with mnemonic",
                    systemImage: "key.fill"
                )
                .font(
                    .system(
                        .headline,
                        design: .rounded,
                        weight: .semibold
                    )
                )
                .foregroundStyle(.foreground)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 28)
            .opacity(appeared ? 1 : 0)
            .offset(y: appeared ? 0 : 16)
            .blur(radius: appeared ? 0 : 8)
            .animation(
                .smooth(duration: 0.65).delay(0.32),
                value: appeared
            )
        }
        .padding(.horizontal, 36)
        .padding(.top, 16)
        .padding(.bottom, 36)
    }
}
