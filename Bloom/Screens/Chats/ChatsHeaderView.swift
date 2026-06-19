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
    
    @Environment(AppRouter.self) private var router
    
    var body: some View {
        VStack(spacing: 0) {
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
                        userId: "dasdsf432$#"
                    )
                }
                .buttonStyle(ScaleButtonStyle())
            }
            .padding(.top, Theme.spacing.md)
            .padding(.horizontal, Theme.spacing.lg)
            .padding(.bottom, Theme.spacing.lg)
        }
        .offset(y: max(0, -scrollY / 5))
        .background(
            ZStack {
                VariableBlur(direction: .down)
                    .dimmingOvershoot(.relative(fraction: 1.35))
                    .passesTouchesThrough(true)
                    .ignoresSafeArea()
                
                LinearGradient(
                    colors: [
                        Theme.colors.background.opacity(1),
                        Theme.colors.background.opacity(0.5),
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
