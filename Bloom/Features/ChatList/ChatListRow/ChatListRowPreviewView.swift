//
//  ChatListRowPreviewView.swift
//  Bloom
//
//  Created by Аскольд on 15.08.2026.
//

import SwiftUI

struct ChatPreviewView: View {
    let userId: Int
    let store: MessagesStore
    
    @State private var isAtBottom = true
    @State private var scrolledID: Int?

    private let bottomSpacerId = Int.min
    private let scrollThreshold: CGFloat = 0
    
    private var previewWidth: CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        return screenWidth - 32
    }

    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                LazyVStack(spacing: 0) {
                    Color.clear
                        .frame(height: 16)
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
            .onChange(of: store.data.count) { oldCount, newCount in
                guard newCount > oldCount else { return }
                withAnimation(.smooth(duration: 0.235)) {
                    scrolledID = bottomSpacerId
                }
            }
            
            ZStack(alignment: .top) {
                VariableBlurView(height: 76, color: Theme.colors.background)
                
                ChatViewToolbarUser(chatId: userId, isPreview: true)
                    .padding()
            }
        }
        .frame(width: previewWidth, height: previewWidth * 1.5)
        .background(Theme.colors.background)
    }
}
