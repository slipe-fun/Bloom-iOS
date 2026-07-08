//
//  AppCoordinatorView.swift
//  Bloom
//
//  Created by Аскольд on 20.06.2026.
//

import SwiftUI

import SwiftUI

struct AppCoordinatorView: View {
    @Environment(AppRouter.self) private var router
    @Environment(BottomSheetManager.self) private var bottomSheetManager
    
    @State private var dragOffset: CGFloat = 0
    @State private var isSwiping: Bool = false
    
    @State private var bottomSheetZIndex: Double = 200

    var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            let safeArea = proxy.safeAreaInsets

            let standardPath = router.standardPath
            let isSettingsTop = router.isSettingsTop
            let isStandardTop = !standardPath.isEmpty
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
                
                let isRootRendered = standardPath.count < 2
                
                Group {
                    if router.isAuthenticated {
                        ChatsScreen()
                            .environment(router)
                            .background(Theme.colors.background.ignoresSafeArea())
                            .modifier(ChatsRootModifier(
                                offset: chatsOffset,
                                isSettingsTransition: isSettingsTop,
                                settingsProgress: settingsProgress,
                                standardProgress: standardProgress,
                                cornerRadius: maxRadius
                            ))
                            .transition(.opacity)
                    } else {
                        WelcomeScreen()
                            .environment(router)
                            .background(Theme.colors.background.ignoresSafeArea())
                            .transition(.opacity)
                    }
                }
                .opacity(isRootRendered ? 1.0 : 0.0)
                .allowsHitTesting(isRootRendered)
                .zIndex(1)

                ForEach(Array(standardPath.enumerated()), id: \.offset) { index, route in
                    let isTop = index == standardPath.count - 1
                    let isPrevious = index == standardPath.count - 2
                    let isRendered = index >= standardPath.count - 2
                    
                    let currentProgress: CGFloat = {
                        if isTop {
                            return isSwiping ? (1.0 - dragOffset / width) : 1.0
                        } else if isPrevious {
                            return isSwiping ? dragOffset / width : 0.0
                        }
                        return 0.0
                    }()
                    
                    let currentOffset: CGFloat = {
                        if isTop {
                            return isSwiping ? dragOffset : 0
                        } else if isPrevious {
                            return isSwiping ? -width * 0.3 * (1.0 - dragOffset / width) : -width * 0.3
                        }
                        return -width * 0.3
                    }()
                    
                    let currentOpacity: CGFloat = {
                        if isTop {
                            return 1.0
                        } else if isPrevious {
                            return max(0.75, min(1.0, 0.75 + 0.25 * currentProgress))
                        }
                        return 0.75
                    }()

                    buildView(for: route)
                        .environment(router)
                        .background(Theme.colors.background.ignoresSafeArea())
                        .modifier(PushedScreenModifier(
                            isTop: isTop,
                            opacity: currentOpacity,
                            offset: currentOffset,
                            progress: currentProgress,
                            cornerRadius: maxRadius
                        ))
                        .opacity(isRendered ? 1.0 : 0.0)
                        .allowsHitTesting(isTop && isRendered)
                        .transition(.screenPush(width: width, cornerRadius: maxRadius))
                        .zIndex(Double(index + 2))
                }
                
                GlobalBottomSheetOverlayView()
                    .zIndex(bottomSheetZIndex)
            }
            .environment(\.customSafeArea, safeArea)
            .ignoresSafeArea()
            .onChange(of: bottomSheetManager.state) { oldValue, newValue in
                if oldValue == .hidden && newValue != .hidden {
                    bottomSheetZIndex = Double(router.standardPath.count) + 1.5
                }
            }
            .overlay(
                Group {
                    if !router.path.isEmpty && bottomSheetManager.state == .hidden {
                        EdgeSwipeGestureView(
                            dragOffset: $dragOffset,
                            isSwiping: $isSwiping,
                            screenWidth: width,
                            onPop: { router.pop(animated: false) }
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
        case .chatDetail(let chatId): ChatScreen(chatId: chatId)
        case .settings: EmptyView()
        }
    }
}
