//
//  ChatHeaderView.swift
//  Bloom
//
//  Created by Аскольд on 05.07.2026.
//

import SwiftUI
import BlurSwiftUI

struct ChatHeaderView: View {
    @Environment(AppRouter.self) private var router
    @Environment(\.customSafeArea.self) private var safeArea
    
    var body: some View {
        GlassEffectContainer{
            HStack(alignment: .top, spacing: Theme.spacing.md) {
                Button {
                    router.pop()
                } label: {
                    IconView(name: "chevron.left_icon", size: 26, color: Theme.colors.text)
                }
                .buttonStyle(.plain)
                .frame(width: 44, height: 44)
                .glassEffect(.clear.interactive().tint(Theme.colors.glassBackdrop))
                
                HStack(spacing: Theme.spacing.md) {
                    AvatarView(size: .md, image: "", id: "DSFSDF#@1223", name: "Dikiy Super")
                        .shadow(color: Theme.colors.shadow, radius: 24, x: 0, y: 0)
                    
                    VStack(alignment: .leading, spacing: Theme.spacing.xs - 1) {
                        Text("Dikiy Super")
                            .font(Theme.font.headline)
                            .foregroundStyle(Theme.colors.text)
                        
                        Text("Last seen recently")
                            .font(Theme.font.footnote)
                            .foregroundStyle(Theme.colors.secondaryText)
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                
                Button {
                    router.pop()
                } label: {
                    IconView(name: "dots_icon", size: 26, color: Theme.colors.text)
                }
                .buttonStyle(.plain)
                .frame(width: 44, height: 44)
                .glassEffect(.clear.interactive().tint(Theme.colors.glassBackdrop))
            }
        }
        .padding(.top, Theme.spacing.md + safeArea.top)
        .padding(.horizontal, Theme.spacing.lg)
        .padding(.bottom, Theme.spacing.md)
        .background(alignment: .bottom) {
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
                .frame(maxHeight: .infinity)
            }
        }
    }
}
