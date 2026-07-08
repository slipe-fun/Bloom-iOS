//
//  ChatsNewMessageHeaderView.swift
//  Bloom
//
//  Created by Аскольд on 28.06.2026.
//

import SwiftUI

struct ChatsNewMessageHeaderView: View {
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
                .font(Theme.font.title4)
                .foregroundStyle(Theme.colors.text)
                .frame(maxWidth: .infinity)
        }
        .padding(.top, Theme.spacing.lg)
        .padding(.leading, Theme.spacing.lg)
        .padding(.trailing, Theme.spacing.lg + 44)
        .padding(.bottom, Theme.spacing.md)
        .topGradientBackground(color: Theme.colors.sectionForeground)
    }
}
