//
//  WelcomeFooterView.swift
//  Bloom
//
//  Created by Аскольд on 24.06.2026.
//

import SwiftUI

struct WelcomeFooterView: View {
    @Environment(AppRouter.self) private var router
    
    var body: some View {
        VStack(alignment: .trailing) {
            Button {
                router.isSettingsPresented = true
            } label: {
                Text("Continue with FaceID")
                .font(Theme.font.semibold(size: Theme.fontSize.lg))
                .foregroundStyle(Theme.colors.white)
            }
            .buttonStyle(.plain)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .glassEffect(.regular.interactive().tint(Theme.colors.primary))
        }
        .padding(.horizontal, Theme.spacing.xxxl + 8)
        .padding(.bottom, Theme.spacing.xxxl + 8)
    }
}
