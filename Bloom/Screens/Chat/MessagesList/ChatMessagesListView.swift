//
//  MessagesListView.swift
//  Bloom
//
//  Created by Аскольд on 28.06.2026.
//

import SwiftUI

struct ChatMessagesListView: View {
    @Environment(MessagesListStore.self) private var store
    @Environment(\.customSafeArea.self) private var safeArea
    
    let bottomInset: CGFloat
    let keyboardHeight: CGFloat
    
    private let bottomSpacerId = "BOTTOM_SPACER"
    
    var body: some View {
        ZStack {
            ScrollView {
                ScrollViewReader { proxy in
                    LazyVStack(spacing: 0) {
                        Color.clear
                            .frame(height: bottomInset + keyboardHeight)
                            .id(bottomSpacerId)

                        ForEach(store.data) { item in
                            ChatMessageCellView(
                                item: item,
                                isSeen: item.id <= store.lastSeenId,
                            )
                            .equatable()
                            .padding(.horizontal, Theme.spacing.lg)
                            .scaleEffect(y: -1)
                            .id(item.id)
                            .transition(.asymmetric(
                                insertion: AnyTransition.opacity.combined(with: .blur(radius: 10)).combined(with: .offset(y: -bottomInset * 1.25)),
                                removal: .opacity
                            ))
                        }
                    }
                    .scrollTargetLayout()
                    .onChange(of: store.data.count) { _, _ in
                        withAnimation(.normalSpring) {
                            proxy.scrollTo(bottomSpacerId, anchor: .top)
                        }
                    }
                }
            }
            .safeAreaInset(edge: .bottom, spacing: 0) {
                ChatHeaderView()
                    .scaleEffect(y: -1)
            }
            .scrollIndicators(.hidden)
            .scaleEffect(y: -1)
            .simultaneousGesture(
                DragGesture().onChanged { value in
                    if abs(value.translation.height) > 0.01 {
                        UIApplication.shared.sendAction(
                            #selector(UIResponder.resignFirstResponder),
                            to: nil,
                            from: nil,
                            for: nil
                        )
                    }
                }
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
