//
//  AppCoordinatorView.swift
//  Bloom
//
//  Created by Аскольд on 20.06.2026.
//

import SwiftUI

struct AppCoordinatorView: View {
    @State private var router = AppRouter()
    @State private var transitionProgress: CGFloat = 0.0
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            
            let topInset = geometry.safeAreaInsets.top - 7
            let maxRadius = topInset > 20 ? topInset : 0.0
            let chatsOffset = -width * transitionProgress
            let settingsOffset = width / 2 + -width / 2 * transitionProgress
            
            ZStack {
                Theme.colors.black.ignoresSafeArea()
                
                SettingsScreen()
                    .environment(router)
                    .background(Color(.systemGroupedBackground).ignoresSafeArea())
                    .settingsBehindStyle(progress: transitionProgress, cornerRadius: transitionProgress >= 0.99 ? 0 : maxRadius, offset: settingsOffset)
                    .disabled(transitionProgress == 0)
                    .zIndex(0)
                
                NavigationStack(path: $router.path) {
                    ChatsScreen()
                        .navigationDestination(for: AppRoute.self) { route in
                            buildView(for: route)
                        }
                }
                .environment(router)
                .background(Color(.systemBackground).ignoresSafeArea())
                .chatsSlideLeftStyle(offset: chatsOffset, cornerRadius: transitionProgress <= 0.01 ? 0 : maxRadius)
                .zIndex(1)
            }
            .ignoresSafeArea()
            .modifier(GlobalSwipeGestureModifier(
                progress: $transitionProgress,
                isPresented: router.isSettingsPresented,
                onEnded: { shouldClose in
                    withAnimation(.quickSpring) {
                        router.isSettingsPresented = !shouldClose
                        transitionProgress = shouldClose ? 0.0 : 1.0
                    }
                }
            ))
            .onChange(of: router.isSettingsPresented) { newValue in
                withAnimation(.quickSpring) {
                    transitionProgress = newValue ? 1.0 : 0.0
                }
            }
        }
    }
    
    @ViewBuilder
    private func buildView(for route: AppRoute) -> some View {
        switch route {
        case .welcome: WelcomeScreen()
        case .chats: ChatsScreen()
        case .chatDetail(let userId): Text("Чат с \(userId)")
        case .settings: SettingsScreen()
        }
    }
}
