//
//  ChatFooterSendView.swift
//  Bloom
//
//  Created by Аскольд on 13.08.2026.
//

import SwiftUI
import DequeModule

struct ChatFooterSendView: View {
    @Binding var text: String
    @Environment(MessagesStore.self) private var store
    
    var hasText: Bool {
        !text.trim().isEmpty
    }
    
    var body: some View {
        Button {
            if hasText {
                let newMessage = MessageItem(
                    id: (store.data.first?.id ?? 0) + 1,
                    content: self.text,
                    date: "12:00",
                    me: Bool.random(),
                    nonce: UUID().uuidString,
                    chatId: 1,
                    authorId: "user_1",
                    groupEnd: true,
                    groupStart: true
                )
                withAnimation(.smooth(duration: 0.235)) {
                    store.data.prepend(newMessage)
                }
                Task { @MainActor in
                    try? await Task.sleep(for: .seconds(3.0))
                    withAnimation(.smooth(duration: 0.235)) {
                        store.lastSeenId = store.data.first?.id ?? 0
                    }
                }
                self.text = ""
            }
        } label: {
            ZStack {
                Image(systemName: "microphone.fill")
                    .font(.headline)
                    .foregroundStyle(.foreground.opacity(0.4))
                    .scaleEffect(hasText ? 0.5 : 1)
                    .opacity(hasText ? 0 : 1)
                
                Circle()
                    .fill(Theme.colors.primary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .scaleEffect(hasText ? 1 : 0)
                    .opacity(hasText ? 1 : 0)
                    .blur(radius: hasText ? 0 : 6)
                
                if hasText {
                    Image(systemName: "arrow.up")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .transition(
                            .asymmetric(
                                insertion: .offset(y: 17).combined(with: .opacity).combined(with: .blur(radius: 3).combined(with: .scale(scale: 0.7))),
                                removal: .offset(y: -17).combined(with: .opacity).combined(with: .blur(radius: 3).combined(with: .scale(scale: 0.7)))
                            )
                        )
                }
            }
            .animation(.smooth(duration: 0.235), value: hasText)
        }
        .animation(.smooth(duration: 0.235), value: text)
        .padding(Theme.spacing.xs + 2)
        .buttonStyle(.plain)
        .frame(width: 46, height: 46)
    }
}
