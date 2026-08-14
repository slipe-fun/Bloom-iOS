//
// ChatView.swift
// Bloom
//
// Created by Аскольд on 11.08.2026.
//

import SwiftUI
import BlurSwiftUI
import BlurUIKit

struct ChatView: View {
    let chatId: Int

    @Environment(MessagesStore.self) private var store
    @State private var isAtBottom = true
    @State private var scrolledID: Int?

    private let bottomSpacerId = Int.min
    private let scrollThreshold: CGFloat = 120

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                Color.clear
                    .frame(height: 1)
                    .id(bottomSpacerId)

                ForEach(store.data) { item in
                    ChatRowView(
                        item: item,
                        isSeen: item.id <= store.lastSeenId
                    )
                    .equatable()
                    .padding(.horizontal, Theme.spacing.lg)
                    .id(item.id)
                    .transition(.asymmetric(
                        insertion: AnyTransition.opacity
                            .combined(with: .blur(radius: 10))
                            .combined(with: .offset(y: -100 * 1.25)),
                        removal: .opacity
                    ))
                    .scaleEffect(y: -1)
                }
            }
            .scrollTargetLayout()
        }
        .scrollIndicators(.hidden)
        .scaleEffect(y: -1)
        .scrollPosition(id: $scrolledID, anchor: .top)
        .onScrollGeometryChange(for: Bool.self) { geometry in
            geometry.contentOffset.y <= scrollThreshold
        } action: { _, newValue in
            isAtBottom = newValue
        }
        .onChange(of: store.data.count) { oldCount, newCount in
            if (store.data.first!.me) {
                guard newCount > oldCount else { return }
                withAnimation(.smooth(duration: 0.235)) {
                    scrolledID = bottomSpacerId
                }
            } else {
                guard newCount > oldCount, isAtBottom else { return }
                withAnimation(.smooth(duration: 0.235)) {
                    scrolledID = bottomSpacerId
                }
            }
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            ChatFooterView()
        }
        .ignoresSafeArea(.container, edges: .bottom)
        .scrollDismissesKeyboard(.interactively)
        .scrollEdgeEffectHidden(true, for: .all)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ChatViewToolbar(chatId: chatId)
        }
        .toolbarBackground(.hidden, for: .navigationBar)
        .topVariableBlur()
        .bottomSafeAreaGradient()
    }
}
