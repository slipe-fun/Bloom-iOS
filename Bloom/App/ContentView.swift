//
//  ContentView.swift
//  Bloom
//
//  Created by Аскольд on 10.08.2026.
//

import SwiftUI

struct ContentView: View {
    @State private var router = Router()
    @State private var store = MessagesStore()
    @Namespace private var heroNamespace
    
    var body: some View {
        NavigationStack(path: $router.path) {
            ChatListView(namespace: heroNamespace)
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .chatList:
                        ChatListView(namespace: heroNamespace)
                    case .chat(let id):
                        ChatView(chatId: id)
                    case .profile(let id):
                        ProfileView(id: id)
                    }
                }
        }
        .sheet(item: $router.presentedSheet, onDismiss: {
            router.pushPendingRouteIfNeeded()
        }) { modal in
            switch modal {
            case .newMessage:
                NewMessageView()
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.hidden)
            case .settings:
                SettingsView()
                    .presentationDetents([.large])
                    .presentationDragIndicator(.hidden)
            }
        }
        .environment(store)
        .environment(router)
        .environment(\.heroNamespace, heroNamespace)
    }
}
