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
    
    let keyboardHeight: CGFloat
    let footerHeight: CGFloat
    
    var body: some View {
        GlassEffectContainer {
            HStack(alignment: .bottom, spacing: Theme.spacing.md) {
                Button {
                   print("Media")
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
                            .font(Theme.font.medium(size: Theme.fontSize.md))
                            .foregroundStyle(Theme.colors.secondaryText),
                        axis: .vertical
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    .contentShape(Rectangle())
                    .lineLimit(1...5)
                    .focused($focused)
                    .font(Theme.font.medium(size: Theme.fontSize.md))
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
                .glassEffect(.clear.interactive().tint(Theme.colors.glassBackdrop), in: RoundedRectangle(cornerRadius: 44 / 2, style: .continuous))
                .contentShape(Rectangle())
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, keyboardHeight > 0 ? Theme.spacing.lg : Theme.spacing.xxxl)
            .padding(.top, Theme.spacing.md)
            .padding(.bottom, keyboardHeight > 0 ? Theme.spacing.lg : Theme.spacing.xxxl)
            .background(alignment: .top) {
                ZStack {
                    LinearGradient(
                        colors: [
                            Theme.colors.background.opacity(0.8),
                            Theme.colors.background.opacity(0.45),
                            Theme.colors.background.opacity(0.0)
                        ],
                        startPoint: .bottom,
                        endPoint: .top
                    )
                    .ignoresSafeArea(edges: .bottom)
                    .frame(height: keyboardHeight > 0 ? 0 : footerHeight)
                }
            }
        }
    }
}
