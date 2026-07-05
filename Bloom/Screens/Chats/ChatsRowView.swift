//
//  ChatRowView.swift
//  Bloom
//
//  Created by Аскольд on 19.06.2026.
//

import SwiftUI

struct ChatsRowView: View {
    @Environment(AppRouter.self) private var router
    
    var userId: Int
    
    var body: some View {
        Button {
            router.push(.chatDetail(chatId: userId))
        } label: {
            HStack(alignment: .top, spacing: 0) {
                AvatarView(size: .lg, id: String(userId), name: String(userId))
                    .padding(.trailing, Theme.spacing.lg)
                    .padding(.vertical, Theme.spacing.md)
                VStack(alignment: .leading, spacing: Theme.spacing.sm - 2) {
                    HStack(spacing: Theme.spacing.xs) {
                        Text("Test name")
                            .font(Theme.font.headline)
                            .foregroundStyle(Theme.colors.text)
                        
                        Spacer()
                        
                        Text("11:11")
                            .font(Theme.font.footnote)
                            .foregroundStyle(Theme.colors.secondaryText)
                        
                        IconView(name: "chevron.right_icon", size: 16, color: Theme.colors.secondaryText)
                    }
                    
                    Text("Test last message")
                        .font(Theme.font.subTitle)
                        .foregroundStyle(Theme.colors.secondaryText)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                }
                .padding(.top, Theme.spacing.md)
                .frame(maxWidth: .infinity, alignment: .topLeading)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, Theme.spacing.lg)
        }
        .buttonStyle(RowButtonStyle())
    }
}
