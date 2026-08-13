//
//  ChatListToolbar.swift
//  Bloom
//
//  Created by Аскольд on 12.08.2026.
//

import SwiftUI


struct ChatListToolbar: ToolbarContent {
    var namespace: Namespace.ID
    let scrollY: CGFloat
    
    @Environment(Router.self) private var router
    
    @ToolbarContentBuilder
    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button {
                print("notifications")
            } label: {
                Image(systemName: "bell.fill")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            .controlSize(.regular)
        }

        ToolbarItem(placement: .principal) {
            HStack(spacing: Theme.spacing.sm) {
                        Image("Logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 19, height: 19)
                            .rotationEffect(.degrees(max(0, -scrollY / 3)))

                        Text("Bloom")
                            .foregroundColor(.primary)
                            .font(.system(.headline, design: .rounded, weight: .bold))
                    }
                    .fixedSize(horizontal: true, vertical: false)
        }
        
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                print("settings")
            } label: {
                AvatarView(size: .md, square: false, image: "", id: "2!#SEe3", name: "Nicolas Cage")
            }
            .buttonStyle(.plain)
            .controlSize(.regular)
            .glassEffect(.regular.interactive())
        }
        .sharedBackgroundVisibility(.hidden)

        DefaultToolbarItem(kind: .search, placement: .bottomBar)

        ToolbarSpacer(.fixed, placement: .bottomBar)

        ToolbarItem(placement: .bottomBar) {
            Button {
                router.presentModal(.newMessage)
            } label: {
                Image(systemName: "square.and.pencil")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            .controlSize(.large)
            .matchedTransitionSource(id: "newMessageButton", in: namespace)
        }
    }
}
