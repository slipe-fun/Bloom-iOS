//
//  ContentView.swift
//  Bloom
//
//  Created by Аскольд on 10.08.2026.
//

import SwiftUI

struct ContentView: View {
    @State private var router = Router()
    @Namespace private var animationNamespace
    
    var body: some View {
        NavigationStack(path: $router.path) {
            ChatListView(namespace: animationNamespace)
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .chatList:
                        ChatListView(namespace: animationNamespace)
                    case .chat(let id):
                        ChatView(chatId: id)
                    }
                }
        }
        .sheet(item: $router.presentedSheet, onDismiss: {
            router.pushPendingRouteIfNeeded()
        }) { modal in
            switch modal {
            case .newMessage:
                NewMessageView(namespace: animationNamespace)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.hidden)
            }
        }
        .environment(router)
    }
}
