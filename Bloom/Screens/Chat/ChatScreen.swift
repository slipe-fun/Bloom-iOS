//
//  ChatScreen.swift
//  Bloom
//
//  Created by Аскольд on 20.06.2026.
//

import SwiftUI

struct ChatScreen: View {
    @Environment(AppRouter.self) private var router
    let chatId: Int
    
    var body: some View {
        VStack(spacing: Theme.spacing.xxl) {
            Button {
                router.push(.chatDetail(chatId: chatId))
                print("id: \(chatId)")
            } label: {
                Text("Login")
                    .font(Theme.font.semibold(size: Theme.fontSize.xxl))
                    .foregroundStyle(Theme.colors.primary)
                    .frame(maxWidth: .infinity)
                    .padding(Theme.spacing.lg)
                    .background(Theme.colors.text)
                    .background(
                        RoundedRectangle(cornerRadius: Theme.radius.full)
                            .fill(Theme.colors.text)
                    )
            }
        }
        .padding(.horizontal, 32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
