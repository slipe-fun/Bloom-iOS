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
            HStack(spacing: Theme.spacing.md) {
                AvatarView(
                    size: .md,
                    id: String(chatId),
                    name: String(chatId)
                )
                
                VStack(alignment: .center, spacing: Theme.spacing.xs) {
                    HStack(alignment: .firstTextBaseline, spacing: Theme.spacing.xs) {
                        Text("Test name")
                            .font(.system(.headline, design: .rounded, weight: .semibold))
                            .foregroundStyle(.primary)
                            .lineLimit(1)
                        
                        Spacer(minLength: Theme.spacing.xs)
                    }
                    
                    HStack(alignment: .firstTextBaseline, spacing: Theme.spacing.xs) {
                        Text("@testusername")
                            .font(.system(.subheadline, design: .rounded, weight: .medium))
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.leading)
                            .lineLimit(1)
                        
                        Spacer(minLength: Theme.spacing.xs)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
            .fixedSize(horizontal: true, vertical: false)
            
        }
        .sharedBackgroundVisibility(.hidden)
        
        ToolbarSpacer(.flexible, placement: .topBarTrailing)

        ToolbarItem(placement: .topBarTrailing) {
            Menu {
                Button {
                    // Действие: Закрепить
                } label: {
                    Label("Pin", systemImage: "pin.fill")
                }

                Button {
                    // Действие: Без звука
                } label: {
                    Label("Mute", systemImage: "bell.slash.fill")
                }

                Divider()

                Button(role: .destructive) {
                    // Действие: Удалить
                } label: {
                    Label("Delete chat", systemImage: "trash.fill")
                }
            } label: {
                Image(systemName: "ellipsis")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
        }
    }
}
