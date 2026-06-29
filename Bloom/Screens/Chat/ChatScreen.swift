//
//  ChatScreen.swift
//  Bloom
//
//  Created by Аскольд on 20.06.2026.
//

import SwiftUI

struct ChatScreen: View {
    @Environment(AppRouter.self) private var router
    @State private var store = MessagesListStore()
    @State private var keyboardHeight: CGFloat = 0
    @State private var footerHeight: CGFloat = 0
    
    let chatId: Int
    
    var body: some View {
        ZStack {
            ChatMessagesListView(bottomInset:footerHeight, keyboardHeight: keyboardHeight)
            KeyboardPinnedView(keyboardHeight: $keyboardHeight, footerHeight: $footerHeight) {
                ChatFooterView(keyboardHeight: keyboardHeight, footerHeight: footerHeight)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .environment(store)
    }
}
