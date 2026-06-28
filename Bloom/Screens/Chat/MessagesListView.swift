//
//  MessagesListView.swift
//  Bloom
//
//  Created by Аскольд on 28.06.2026.
//

import SwiftUI

struct MessagesListView: View {
    let store: MessageListStore
    let bottomInset: CGFloat
    let keyboardHeight: CGFloat
    
    private let bottomSpacerId = "BOTTOM_SPACER"
    
    var body: some View {
        ZStack {
            
            ScrollView {
                ScrollViewReader { proxy in
                    LazyVStack(spacing: 4) {
                        Color.clear
                            .frame(height: bottomInset + keyboardHeight)
                        .id(bottomSpacerId)

                        ForEach(store.data) { item in
                            MessageCellView(
                                item: item,
                                isSeen: item.id <= store.lastSeenId,
                            )
                            .equatable()
                            .padding(.horizontal, 16)
                            .scaleEffect(y: -1)
                            .id(item.id)
                            .transition(.asymmetric(
                                insertion: AnyTransition.opacity.combined(with: .blur(radius: 10)).combined(with: .offset(y: -bottomInset * 1.25)),
                                removal: .opacity
                            ))
                        }
                    }
                    .scrollTargetLayout()
                    .padding(.bottom, store.contentInsetTop)
                    .onChange(of: store.indexedItems.count) { _, _ in
                        withAnimation(.quickSpring) {
                            proxy.scrollTo(bottomSpacerId, anchor: .top)
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
            .scaleEffect(y: -1)
            .simultaneousGesture(
                DragGesture().onChanged { value in
                    if abs(value.translation.height) > 10 {
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
