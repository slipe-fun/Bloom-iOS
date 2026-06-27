//
//  ChatsHeaderView.swift
//  Bloom
//
//  Created by Аскольд on 19.06.2026.
//

import SwiftUI
import BlurSwiftUI

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
                        .font(Theme.font.bold(size: Theme.fontSize.xxl))
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
                        userId: "dasdsf432"
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
        .background(
            ZStack {
                VariableBlur(direction: .down)
                    .dimmingOvershoot(.relative(fraction: 1.35))
                    .passesTouchesThrough(true)
                    .ignoresSafeArea()
                
                LinearGradient(
                    colors: [
                        Theme.colors.background.opacity(0.8),
                        Theme.colors.background.opacity(0.45),
                        Theme.colors.background.opacity(0.0)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea(edges: .top)
            }
        )
    }
}
