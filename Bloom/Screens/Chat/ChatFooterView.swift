//
//  ChatFooterView.swift
//  Bloom
//
//  Created by Аскольд on 29.06.2026.
//

import SwiftUI

struct ChatFooterView: View {
    @State private var text: String = ""
    @FocusState private var focused: Bool
    @Environment(MessagesListStore.self) private var store
    @Environment(BottomSheetManager.self) private var bottomSheetManager
    
    let keyboardHeight: CGFloat
    let footerHeight: CGFloat
    let isKeyboardVisible: Bool
    
    var body: some View {
        GlassEffectContainer {
            HStack(alignment: .bottom, spacing: Theme.spacing.md) {
                Button {
                    bottomSheetManager.present {
                        ChatMediaSheetView()
                            .bindBottomSheetScrollOffset(to: bottomSheetManager)
                    }
                } label: {
                    IconView(name: "plus_icon", size: 26, color: Theme.colors.text)
                }
                .buttonStyle(.plain)
                .frame(width: 44, height: 44)
                .glassEffect(.clear.interactive().tint(Theme.colors.glassBackdrop))
                
                HStack(alignment: .bottom, spacing: Theme.spacing.xs) {
                    TextField(
                        "",
                        text: $text,
                        prompt:
                            Text("Type a message...")
                            .font(Theme.font.body)
                            .foregroundStyle(Theme.colors.secondaryText),
                        axis: .vertical
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    .contentShape(Rectangle())
                    .lineLimit(1...5)
                    .focused($focused)
                    .font(Theme.font.body)
                    .padding(.leading, Theme.spacing.lg)
                    .padding(.vertical, Theme.spacing.md)
                    .foregroundStyle(Theme.colors.text)
                    .textFieldStyle(.plain)
                    .tint(Theme.colors.primary)
                    
                    ChatFooterSendView(text: $text)
                }
                .onTapGesture {
                    self.focused = true
                }
                .frame(maxWidth: .infinity)
                .frame(minHeight: 44)
                .glassEffect(.clear.interactive().tint(Theme.colors.glassBackdrop), in: RoundedRectangle(cornerRadius: 44 / 2))
                .contentShape(Rectangle())
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, isKeyboardVisible ? Theme.spacing.lg : Theme.spacing.xxxl)
        .padding(.top, Theme.spacing.md)
        .padding(.bottom, isKeyboardVisible ? Theme.spacing.lg : Theme.spacing.xxxl)
        .bottomGradientBackground(color: Theme.colors.background, height: isKeyboardVisible ? 0 : footerHeight)
    }
}
