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
    @State private var isKeyboardVisible: Bool = false
    
    let chatId: Int
    
    var body: some View {
        ZStack {
            ChatMessagesListView(bottomInset:footerHeight, keyboardHeight: keyboardHeight)
            KeyboardPinnedView(keyboardHeight: $keyboardHeight, footerHeight: $footerHeight, isKeyboardVisible: $isKeyboardVisible) {
                ChatFooterView(keyboardHeight: keyboardHeight, footerHeight: footerHeight, isKeyboardVisible: isKeyboardVisible)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .environment(store)
    }
}
