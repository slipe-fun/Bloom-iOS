//
//  ChatFooterSendView.swift
//  Bloom
//
//  Created by Аскольд on 29.06.2026.
//

import SwiftUI

struct ChatFooterSendView: View {
    @Binding var text: String
    @Environment(MessagesListStore.self) private var store
    
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
                withAnimation(.quickSpring) {
                    store.data.insert(newMessage, at: 0)
                }
                self.text = ""
            }
        } label: {
            ZStack {
                IconView(name: "waveform_icon", size: 26, color: Theme.colors.secondaryText)
                .scaleEffect(hasText ? 0.5 : 1)
                .opacity(hasText ? 0 : 1)
                
                Circle()
                    .fill(Theme.colors.primary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .scaleEffect(hasText ? 1 : 0)
                    .opacity(hasText ? 1 : 0)
                    .blur(radius: hasText ? 0 : 6)
                
                if hasText {
                    IconView(name: "paperplane_icon", size: 26, color: Theme.colors.white)
                        .transition(
                            .asymmetric(
                                insertion: .offset(x: -12, y: 12).combined(with: .opacity).combined(with: .blur(radius: 3).combined(with: .scale(scale: 0.8))),
                                removal: .offset(x: 12, y: -12).combined(with: .opacity).combined(with: .blur(radius: 3).combined(with: .scale(scale: 0.8)))
                            )
                        )
                }
            }
            .animation(.normalSpring, value: hasText)
        }
        .padding(Theme.spacing.xs)
        .buttonStyle(.plain)
        .frame(width: 44, height: 44)
    }
}
