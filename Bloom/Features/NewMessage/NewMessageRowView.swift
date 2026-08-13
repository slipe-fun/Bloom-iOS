//
//  NewMessageRowView.swift
//  Bloom
//
//  Created by Аскольд on 12.08.2026.
//

import SwiftUI

struct NewMessageRowView: View {
    let userId: Int
    @Environment(Router.self) private var router

    var body: some View {
        Button {
            router.selectChat(id: userId)
        } label: {
            HStack(alignment: .top, spacing: 0) {
                AvatarView(
                    size: .md,
                    id: String(userId),
                    name: String(userId)
                )
                .padding(.trailing, Theme.spacing.lg)
                .padding(.vertical, Theme.spacing.md)

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
            .frame(maxWidth: .infinity)
            .padding(.horizontal, Theme.spacing.lg)
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
    }
}
