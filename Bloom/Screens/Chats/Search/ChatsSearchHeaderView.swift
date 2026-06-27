//
//  ChatsSearchHeaderView.swift
//  Bloom
//
//  Created by Аскольд on 27.06.2026.
//

import SwiftUI
import BlurSwiftUI

struct ChatsSearchHeaderView: View {
    let scrollY: CGFloat
    let collapsed: Bool
    
    @Environment(\.customSafeArea) private var safeArea
    
    var body: some View {
        HStack {
            Text("Search")
                .font(Theme.font.bold(size: Theme.fontSize.xxxl))
                .foregroundStyle(Theme.colors.text)
                
            Spacer()
        }
        .padding(.top, Theme.spacing.xxxl + safeArea.top)
        .padding(.horizontal, Theme.spacing.lg)
        .padding(.bottom, Theme.spacing.md)
        .offset(y: min(-scrollY, -scrollY / 4))
        .ignoresSafeArea(edges: .top)
        .opacity(collapsed ? 0 : 1)
    }
}

struct ChatsSearchFloatHeaderView: View {
    @Environment(\.customSafeArea) var safeArea
    
    var body: some View {
        ZStack(alignment: .center) {
            Text("Search")
                .font(Theme.font.semibold(size: Theme.fontSize.lg))
                .foregroundStyle(Theme.colors.text)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, Theme.spacing.md + safeArea.top)
        .padding(.horizontal, Theme.spacing.lg)
        .padding(.bottom, Theme.spacing.xxl)
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
