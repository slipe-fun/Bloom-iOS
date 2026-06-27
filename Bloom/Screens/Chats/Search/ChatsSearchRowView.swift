//
//  ChatsSearchRowView.swift
//  Bloom
//
//  Created by Аскольд on 27.06.2026.
//

import SwiftUI

struct ChatsSearchRowView: View {
    @Environment(AppRouter.self) private var router
    
    var userId: Int
    
    var body: some View {
        Button {
            router.push(.chatDetail(chatId: userId))
        } label: {
            HStack(alignment: .top, spacing: 0) {
                AvatarView(size: .md, id: String(userId), name: String(userId))
                    .padding(.trailing, Theme.spacing.lg)
                    .padding(.vertical, Theme.spacing.md)
                VStack(alignment: .leading, spacing: Theme.spacing.sm - 2) {
                    HStack(spacing: Theme.spacing.xs) {
                        Text("Test name")
                            .font(Theme.font.semibold(size: Theme.fontSize.md))
                            .foregroundStyle(Theme.colors.text)
                        
                        Spacer()
                        
                        IconView(name: "chevron.right_icon", size: 16, color: Theme.colors.secondaryText)
                    }
                    
                    Text("@username")
                        .font(Theme.font.medium(size: Theme.fontSize.sm))
                        .foregroundStyle(Theme.colors.secondaryText)
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
