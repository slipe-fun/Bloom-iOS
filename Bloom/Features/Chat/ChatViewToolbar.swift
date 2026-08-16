//
//  ChatViewToolbar.swift
//  Bloom
//
//  Created by Аскольд on 12.08.2026.
//

import SwiftUI

struct ChatViewToolbar: ToolbarContent {
    let chatId: Int

    @Environment(Router.self) private var router
    
    @ToolbarContentBuilder
    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            ChatViewToolbarUser(chatId: chatId, isPreview: false)
            .fixedSize(horizontal: true, vertical: false)
            
        }
        .sharedBackgroundVisibility(.hidden)
        
        ToolbarSpacer(.flexible, placement: .topBarTrailing)

        ToolbarItem(placement: .topBarTrailing) {
            ChatViewToolbarMenu()
        }
    }
}

struct ChatViewToolbarUser: View {
    let chatId: Int
    let isPreview: Bool
    
    @Environment(\.heroNamespace) private var namespace
    
    var body: some View {
        if isPreview {
            content
        } else {
            NavigationLink(value: Route.profile(id: chatId)) {
                content
            }
            .buttonStyle(.plain)
        }
    }
    
    private var content: some View {
        HStack(spacing: Theme.spacing.md) {
            AvatarView(
                size: .md,
                id: String(chatId),
                name: String(chatId)
            )
            
            VStack(alignment: .center, spacing: Theme.spacing.xs) {
                HStack(alignment: .firstTextBaseline, spacing: Theme.spacing.xs) {
                    Text("Chat with \(chatId)")
                        .font(.system(.headline, design: .rounded, weight: .semibold))
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                    
                    Spacer(minLength: Theme.spacing.xs)
                }
                
                HStack(alignment: .firstTextBaseline, spacing: Theme.spacing.xs) {
                    Text("Last seen recently")
                        .font(.system(.subheadline, design: .rounded, weight: .medium))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.leading)
                        .lineLimit(1)
                    
                    Spacer(minLength: Theme.spacing.xs)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: isPreview ? nil : .infinity, alignment: .center)
        }
    }
}
