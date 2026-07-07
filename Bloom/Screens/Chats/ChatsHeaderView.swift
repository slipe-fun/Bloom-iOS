//
//  ChatsHeaderView.swift
//  Bloom
//
//  Created by Аскольд on 19.06.2026.
//

import SwiftUI

struct ChatsHeaderView: View {
    let title: String
    let scrollY: CGFloat
    
    @Environment(\.customSafeArea) var safeArea
    @Environment(AppRouter.self) private var router
    
    var body: some View {
            HStack {
                HStack {
                    IconView(name: "logo_icon", size: 30, color: Theme.colors.primary)
                        .rotationEffect(.degrees(max(0, -scrollY / 3)))
                    Text(title)
                        .font(Theme.font.title2)
                        .foregroundStyle(Theme.colors.text)
                }
                
                Spacer()
                
                Button {
                    router.isSettingsPresented = true
                } label: {
                    AvatarView(
                        size: .md,
                        square: false,
                        image: "",
                        id: "dasdsf432",
                        name: "Dikiy Super"
                    )
                }
                .buttonStyle(.plain)
                .glassEffect(.clear.interactive().tint(Theme.colors.background))
            }
            .padding(.top, Theme.spacing.md + safeArea.top)
            .padding(.horizontal, Theme.spacing.lg)
            .padding(.bottom, Theme.spacing.md)
        .offset(y: max(0, -scrollY / 4))
        .ignoresSafeArea(edges: .top)
        .topGradientBackground(color: Theme.colors.background)
    }
}
