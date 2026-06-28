//
//  NewMessageHeaderView.swift
//  Bloom
//
//  Created by Аскольд on 28.06.2026.
//

import SwiftUI
import BlurSwiftUI

struct NewMessageHeaderView: View {
    @Environment(BottomSheetManager.self) private var bottomSheetManager
    
    var body: some View {
            HStack(spacing: 0) {
                Button {
                    bottomSheetManager.dismiss()
                } label: {
                    IconView(name: "x_icon", size: 26, color: Theme.colors.text)
                }
                .buttonStyle(.plain)
                .frame(width: 44, height: 44)
                .glassEffect(.clear.interactive().tint(Theme.colors.glassBackdrop))
                
                Text("New message")
                    .font(Theme.font.semibold(size: Theme.fontSize.lg))
                    .foregroundStyle(Theme.colors.text)
                    .frame(maxWidth: .infinity)
            }
            .padding(.top, Theme.spacing.lg)
            .padding(.leading, Theme.spacing.lg)
            .padding(.trailing, Theme.spacing.lg + 44)
            .padding(.bottom, Theme.spacing.md)
        .ignoresSafeArea(edges: .top)
        .background(
            ZStack {
                VariableBlur(direction: .down)
                    .dimmingOvershoot(.relative(fraction: 1.35))
                    .passesTouchesThrough(true)
                    .ignoresSafeArea()
                
                LinearGradient(
                    colors: [
                        Theme.colors.sectionForeground.opacity(0.8),
                        Theme.colors.sectionForeground.opacity(0.45),
                        Theme.colors.sectionForeground.opacity(0.0)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea(edges: .top)
            }
        )
    }
}
