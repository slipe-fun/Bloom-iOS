//
//  ChatFooterView.swift
//  Bloom
//
//  Created by Аскольд on 29.06.2026.
//

import SwiftUI

struct ChatFooterView: View {
    @State private var sex: String = ""
    @FocusState private var focused: Bool
    
    let keyboardHeight: CGFloat
    let footerHeight: CGFloat
    let store: MessageListStore
    
    var body: some View {
        GlassEffectContainer {
            HStack(spacing: Theme.spacing.md) {
                Button {
                   print("Media")
                } label: {
                    IconView(name: "plus_icon", size: 26, color: Theme.colors.text)
                }
                .buttonStyle(.plain)
                .frame(width: 44, height: 44)
                .glassEffect(.clear.interactive().tint(Theme.colors.glassBackdrop))
                
                HStack(spacing: Theme.spacing.sm) {
                    TextField(
                        "",
                        text: $sex,
                        prompt:
                            Text("Type a message...")
                            .font(Theme.font.medium(size: Theme.fontSize.md))
                            .foregroundStyle(Theme.colors.secondaryText)
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentShape(Rectangle())
                    .focused($focused)
                    .font(Theme.font.medium(size: Theme.fontSize.md))
                    .padding(.leading, Theme.spacing.lg)
                    .foregroundStyle(Theme.colors.text)
                    .textFieldStyle(.plain)
                    .tint(Theme.colors.primary)
                    
                    Button {
                        let newMessage = MessageItem(
                            id: (store.data.first?.id ?? 0) + 1,
                            content: self.sex,
                            seen: "Прочитано",
                            date: "12:00",
                            me: Bool.random(),
                            nonce: UUID().uuidString,
                            chatId: 1,
                            authorId: "user_1",
                            groupEnd: true,
                            groupStart: true
                        )
                        withAnimation(.quickSpring) {
                            store.data.insert(newMessage, at: 0)
                        }
                    } label: {
                        IconView(name: "waveform_icon", size: 26, color: Theme.colors.secondaryText)
                    }
                    .buttonStyle(.plain)
                    .frame(width: 44, height: 44)
                }
                .onTapGesture {
                    self.focused = true
                }
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .glassEffect(.clear.interactive().tint(Theme.colors.glassBackdrop))
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
