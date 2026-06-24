//
//  AppCoordinatorView.swift
//  Bloom
//
//  Created by Аскольд on 20.06.2026.
//

import SwiftUI

struct AppCoordinatorView: View {
    @State private var router = AppRouter()
    @State private var dragOffset: CGFloat = 0
    @State private var isSwiping: Bool = false

    var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            let safeArea = proxy.safeAreaInsets

            let topRoute = router.path.last
            let isSettingsTop = topRoute == .settings
            let isStandardTop = topRoute != nil && topRoute != .settings
            let maxRadius = safeArea.top > 20 ? safeArea.top - 4 : 0.0

            let settingsProgress: CGFloat = {
                if isSettingsTop { return isSwiping ? max(0, 1.0 - dragOffset / width) : 1.0 }
                return 0.0
            }()

            let standardProgress: CGFloat = {
                if isStandardTop { return isSwiping ? max(0, 1.0 - dragOffset / width) : 1.0 }
                return 0.0
            }()

            let chatsOffset: CGFloat = {
                if isSettingsTop { return -width * settingsProgress }
                if isStandardTop { return -width * 0.3 * standardProgress }
                return 0.0
            }()

            ZStack {
                Theme.colors.background.ignoresSafeArea()
                
                if router.isAuthenticated {
                    SettingsScreen()
                        .environment(router)
                        .background(Theme.colors.grayBackground.ignoresSafeArea())
                        .modifier(SettingsBehindModifier(progress: settingsProgress, cornerRadius: maxRadius))
                        .allowsHitTesting(isSettingsTop)
                        .zIndex(0)
                }
                
                Group {
                    if router.isAuthenticated {
                        ChatsScreen()
                            .environment(router)
                            .background(Theme.colors.background.ignoresSafeArea())
                            .modifier(ChatsRootModifier(offset: chatsOffset, isSettingsTransition: isSettingsTop, progress: settingsProgress, cornerRadius: maxRadius))
                            .transition(.opacity)
                    } else {
                        WelcomeScreen()
                            .environment(router)
                            .background(Theme.colors.background.ignoresSafeArea())
                            .transition(.opacity)
                    }
                }
                .allowsHitTesting(router.path.isEmpty)
                .zIndex(1)

                ForEach(Array(router.path.enumerated()), id: \.offset) { index, route in
                    if route != .settings {
                        let isTop = index == router.path.count - 1
                        let currentOffset = (isTop && isSwiping) ? dragOffset : 0
                        let currentProgress = (isTop && isSwiping) ? max(0, 1.0 - dragOffset / width) : 1.0

                        buildView(for: route)
                            .environment(router)
                            .background(Theme.colors.background.ignoresSafeArea())
                            .modifier(PushedScreenModifier(offset: currentOffset, progress: currentProgress))
                            .zIndex(CGFloat(index + 2))
                            .transition(.screenPush)
                    }
                }
            }
            .environment(\.customSafeArea, safeArea)
            .ignoresSafeArea()
            .overlay(
                Group {
                    if !router.path.isEmpty {
                        EdgeSwipeGestureView(
                            dragOffset: $dragOffset,
                            isSwiping: $isSwiping,
                            onPop: { router.pop() }
                        )
                        .frame(width: 20)
                    }
                },
                alignment: .leading
            )
        }
    }

    @ViewBuilder
    private func buildView(for route: AppRoute) -> some View {
        switch route {
        case .welcome: WelcomeScreen()
        case .chats: ChatsScreen()
        case .chatDetail(let userId): Text("Chat with \(userId)").frame(maxWidth: .infinity, maxHeight: .infinity)
        case .settings: EmptyView()
        }
    }
}
