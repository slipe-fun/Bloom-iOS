//
//  ChatRowView.swift
//  Bloom
//
//  Created by Аскольд on 19.06.2026.
//

import SwiftUI

struct ChatRowView: View {
    var userId: String
    
    var body: some View {
        Button {
            print("New chat")
        } label: {
            HStack(alignment: .top, spacing: 0) {
                AvatarView(size: .xl, userId: userId)
                    .padding(.trailing, Theme.spacing.lg)
                    .padding(.vertical, Theme.spacing.md)
                VStack(alignment: .leading, spacing: Theme.spacing.sm - 2) {
                    HStack {
                        Text("Test name")
                            .font(Theme.font.semibold(size: Theme.fontSize.md))
                            .foregroundStyle(Theme.colors.text)
                        
                        Spacer()
                        
                        Text("11:11")
                            .font(Theme.font.medium(size: Theme.fontSize.sm))
                            .foregroundStyle(Theme.colors.secondaryText)
                    }
                    
                    Text("Test last message")
                        .font(Theme.font.medium(size: Theme.fontSize.sm))
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
