//
//  ChatFooterView.swift
//  Bloom
//
//  Created by Аскольд on 12.08.2026.
//

import SwiftUI

struct ChatFooterView: View {
    @State private var text: String = ""
    @FocusState private var focused: Bool
    @State private var isKeyboardVisible = false
    
    var body: some View {
        GlassEffectContainer {
            HStack(alignment: .bottom, spacing: Theme.spacing.md) {
                Menu {
                    Button {
                    } label: {
                        Label("Pin", systemImage: "pin.fill")
                    }

                    Button {
                    } label: {
                        Label("Mute", systemImage: "bell.slash.fill")
                    }

                    Divider()

                    Button(role: .destructive) {
                    } label: {
                        Label("Delete chat", systemImage: "trash.fill")
                    }
                } label: {
                        Image(systemName: "plus")
                            .foregroundStyle(.primary)
                            .font(.title3)
                }
                .buttonStyle(.plain)
                .frame(width: 44, height: 44)
                .glassEffect(.regular.interactive())
                .animation(.smooth(duration: 0.235), value: text)
                
                HStack(alignment: .bottom, spacing: Theme.spacing.xs) {
                    TextField(
                        "",
                        text: $text,
                        prompt:
                            Text("Type a message...")
                            .font(.system(.headline, design: .rounded, weight: .medium))
                            .foregroundStyle(.primary),
                        axis: .vertical
                    )
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentShape(Rectangle())
                    .lineLimit(1...5)
                    .focused($focused)
                    .font(.system(.headline, design: .rounded, weight: .medium))
                    .padding(.leading, Theme.spacing.lg)
                    .padding(.vertical, Theme.spacing.md)
                    .foregroundStyle(.primary)
                    .textFieldStyle(.plain)
                    .tint(Theme.colors.primary)
                    
                    ChatFooterSendView(text: $text)
                }
                .animation(.smooth(duration: 0.235), value: text)
                .onTapGesture {
                    self.focused = true
                }
                .frame(maxWidth: .infinity)
                .frame(minHeight: 44)
                .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 44 / 2))
                .contentShape(Rectangle())
            }
            .animation(.smooth(duration: 0.235), value: text)
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, isKeyboardVisible ? Theme.spacing.lg : Theme.spacing.xxxl)
        .padding(.top, Theme.spacing.md)
        .padding(.bottom, isKeyboardVisible ? Theme.spacing.lg : Theme.spacing.xxxl)
        .animation(.smooth(duration: 0.235), value: isKeyboardVisible)
        .background(
            LinearGradient(
                colors: [
                    Color(.systemBackground).opacity(0.8),
                    Color(.systemBackground).opacity(0.45),
                    Color(.systemBackground).opacity(0)
                ],
                startPoint: .bottom,
                endPoint: .top
            )
            .frame(height: isKeyboardVisible ? 0 : nil)
        )
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
            isKeyboardVisible = true
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            isKeyboardVisible = false
        }
        .animation(.smooth(duration: 0.235), value: text)
    }
}
