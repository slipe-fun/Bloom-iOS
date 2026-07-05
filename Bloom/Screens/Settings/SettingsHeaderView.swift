//
//  SettingsHeaderView.swift
//  Bloom
//
//  Created by Аскольд on 21.06.2026.
//

import SwiftUI
import BlurSwiftUI

struct SettingsHeaderView: View {
    let title: String
    
    @Environment(\.customSafeArea) var safeArea
    @Environment(AppRouter.self) private var router
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center) {
                Text(title)
                    .font(Theme.font.title4)
                    .foregroundStyle(Theme.colors.text)
            }
            .padding(.top, Theme.spacing.md + safeArea.top)
            .padding(.horizontal, Theme.spacing.lg)
            .padding(.bottom, Theme.spacing.lg)
        }
        .frame(maxWidth: .infinity)
        .ignoresSafeArea(edges: .top)
        .background(
            ZStack {
                VariableBlur(direction: .down)
                    .dimmingOvershoot(.relative(fraction: 1.35))
                    .passesTouchesThrough(true)
                    .ignoresSafeArea()
                
                LinearGradient(
                    colors: [
                        Theme.colors.grayBackground.opacity(1),
                        Theme.colors.grayBackground.opacity(0.5),
                        Theme.colors.grayBackground.opacity(0.0)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea(edges: .top)
            }
        )
    }
}
