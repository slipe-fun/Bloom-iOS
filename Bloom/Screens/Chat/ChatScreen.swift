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
    
    let chatId: Int
    
    var body: some View {
        ZStack {
            ChatMessagesListView()
            ChatFooterView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .environment(store)
    }
}
