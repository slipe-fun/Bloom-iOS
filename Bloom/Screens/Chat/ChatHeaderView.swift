//
//  ChatHeaderView.swift
//  Bloom
//
//  Created by Аскольд on 05.07.2026.
//

import SwiftUI

struct ChatHeaderView: View {
    @Environment(AppRouter.self) private var router
    @Environment(BottomSheetManager.self) private var bottomSheetManager
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
                
                Button {
                    bottomSheetManager.present {
                        ChatUserSheetView()
                            .bindBottomSheetScrollOffset(to: bottomSheetManager)
                    }
                } label: {
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
                }
                .buttonStyle(.plain)
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
        .topGradientBackground(color: Theme.colors.background)
    }
}
