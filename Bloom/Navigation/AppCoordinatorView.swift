//
//  AppCoordinatorView.swift
//  Bloom
//
//  Created by Аскольд on 20.06.2026.
//

import SwiftUI

struct AppCoordinatorView: View {
    @State private var router = AppRouter()
    @State private var dragX: CGFloat = 0
    @State private var isDragging: Bool = false
    
    var body: some View {
        let width = UIScreen.main.bounds.width
        
        let progress = router.isSettingsPresented ? max(0.0, min(1.0, 1.0 - dragX / width)) : 0.0
        
        let chatsOffset = router.isSettingsPresented ? (-width + dragX) : 0
        
        ZStack {
            Color.black.ignoresSafeArea()
            
            SettingsScreen()
                .environment(router)
                .settingsBehindStyle(progress: progress)
                .disabled(progress == 0)
                .zIndex(0)
            
            NavigationStack(path: $router.path) {
                ChatsScreen()
                    .navigationDestination(for: AppRoute.self) { route in
                        buildView(for: route)
                    }
            }
            .environment(router)
            .chatsSlideLeftStyle(offset: chatsOffset, progress: progress)
            .zIndex(1)
        }
        .ignoresSafeArea()
        .gesture(
            router.isSettingsPresented ?
            DragGesture(minimumDistance: 15)
                .onChanged { value in
                    if value.translation.width > 0 && abs(value.translation.height) < 35 {
                        isDragging = true
                        dragX = value.translation.width
                    }
                }
                .onEnded { value in
                    isDragging = false
                    if value.translation.width > width * 0.3 {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            router.isSettingsPresented = false
                            dragX = 0
                        }
                    } else {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            dragX = 0
                        }
                    }
                }
            : nil
        )
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: router.isSettingsPresented)
    }
    
    @ViewBuilder
    private func buildView(for route: AppRoute) -> some View {
        switch route {
        case .welcome: WelcomeScreen()
        case .chats: ChatsScreen()
        case .chatDetail(let userId): Text("Чат с \(userId)")
        case .settings: EmptyView()
        }
    }
}
