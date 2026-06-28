//
//  MessageCellView.swift
//  Bloom
//
//  Created by Аскольд on 28.06.2026.
//

import SwiftUI

struct MessageCellView: View, Equatable {
    let item: MessageItem
    let isSeen: Bool

    static func == (lhs: MessageCellView, rhs: MessageCellView) -> Bool {
        lhs.item.id == rhs.item.id &&
        lhs.item.content == rhs.item.content &&
        lhs.isSeen == rhs.isSeen
    }

    private var textColor: Color {
        item.me ? Theme.colors.white : Theme.colors.text
    }

    private var backgroundColor: Color {
        item.me ? Theme.colors.primary : Theme.colors.foreground
    }
    

    private var messageBubble: some View {
        let invisibleSpaceForTime = Text("\u{00A0}\u{00A0}" + item.date)
            .font(Theme.font.regular(size: Theme.fontSize.xs))
            .foregroundColor(.clear)

        return Text("\(item.content)\(invisibleSpaceForTime)")
            .font(Theme.font.medium(size: Theme.fontSize.md))
            .foregroundColor(textColor)
            .padding(.horizontal, 15)
            .padding(.vertical, 11)
            .frame(minWidth: 60, minHeight: 40, alignment: .leading)
            .background(backgroundColor, in: .rect(cornerRadius: 22, style: .continuous))
            .overlay(
                Text(item.date)
                    .font(Theme.font.regular(size: Theme.fontSize.xs))
                    .foregroundColor(textColor.opacity(0.5))
                    .padding(.trailing, 13)
                    .padding(.bottom, 9),
                alignment: .bottomTrailing
            )
    }

    var body: some View {
        HStack {
            if item.me {
                Spacer(minLength: 55)
            }

            VStack(alignment: item.me ? .trailing : .leading, spacing: 8) {
                messageBubble
                
                if item.me && isSeen {
                    Text(item.seen ?? "Read")
                        .font(Theme.font.medium(size: Theme.fontSize.sm))
                        .foregroundColor(Theme.colors.secondaryText)
                        .transition(.opacity)
                }
            }

            if !item.me {
                Spacer(minLength: 55)
            }
        }
        .contentShape(.rect)
        .animation(.springy, value: isSeen)
    }
}
