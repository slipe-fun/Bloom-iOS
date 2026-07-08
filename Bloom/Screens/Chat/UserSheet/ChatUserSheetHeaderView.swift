//
//  ChatUserSheetHeaderView.swift
//  Bloom
//
//  Created by Аскольд on 08.07.2026.
//

import SwiftUI

struct ChatUserSheetHeaderView: View {
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
                
                Spacer()
                
                Button {
                    bottomSheetManager.dismiss()
                } label: {
                    IconView(name: "qrcode_icon", size: 26, color: Theme.colors.text)
                }
                .buttonStyle(.plain)
                .frame(width: 44, height: 44)
                .glassEffect(.clear.interactive().tint(Theme.colors.glassBackdrop))
            }
            .padding(.top, Theme.spacing.lg)
            .padding(.horizontal, Theme.spacing.lg)
            .padding(.bottom, Theme.spacing.md)
            .topGradientBackground(color: Theme.colors.sectionForeground)
    }
}
