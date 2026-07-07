//
//  MessageCellView.swift
//  Bloom
//
//  Created by Аскольд on 28.06.2026.
//

import SwiftUI

struct ChatMessageCellView: View, Equatable {
    let item: MessageItem
    let isSeen: Bool

    static func == (lhs: ChatMessageCellView, rhs: ChatMessageCellView) -> Bool {
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
    
    private var emojiSize: CGFloat {
        let count = CGFloat(item.content.count)
        
        guard count > 0 else { return 0 }
        
        let size: CGFloat
        
        switch count {
        case 1:
            size = 120.0
        case 2:
            size = 80.0
        default:
            size = 120.0 / (count * 0.75)
        }
        
        return max(32.0, size)
    }
    
    @ViewBuilder
    private var messageBubble: some View {
        let invisibleSpaceForTime = Text("\u{00A0}\u{00A0}" + item.date)
            .font(Theme.font.messageTime)
            .foregroundColor(.clear)

        if item.content.isOnlyEmojis {
            Text(item.content)
                .font(Theme.fonts.medium(size: emojiSize))
                .padding(.bottom, item.content.isSingleEmoji ? 0 : Theme.spacing.xxl)
                .overlay(
                    Text(item.date)
                        .font(Theme.font.messageTime)
                        .foregroundColor(Theme.colors.text)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 20)),
                    alignment: item.me ? .bottomTrailing : .bottomLeading
                )
        } else {
            Text("\(item.content)\(invisibleSpaceForTime)")
                .font(Theme.font.body)
                .foregroundColor(textColor)
                .padding(.horizontal, 15)
                .padding(.vertical, 11)
                .frame(minWidth: 60, minHeight: 40, alignment: .leading)
                .background(backgroundColor, in: RoundedRectangle(cornerRadius: 22))
                .overlay(
                    Text(item.date)
                        .font(Theme.font.messageTime)
                        .foregroundColor(textColor.opacity(0.5))
                        .padding(.trailing, 13)
                        .padding(.bottom, 9),
                    alignment: .bottomTrailing
                )
        }
    }

    var body: some View {
        HStack {
            if item.me {
                Spacer(minLength: 55)
            }

            VStack(alignment: item.me ? .trailing : .leading, spacing: 0) {
                messageBubble
                
                if item.me {
                    Text("Read")
                        .font(Theme.font.subTitle)
                        .foregroundColor(Theme.colors.secondaryText)
                        .padding(.top, isSeen ? Theme.spacing.sm : 0)
                        .frame(height: isSeen ? nil : 0, alignment: .top)
                        .opacity(isSeen ? 1 : 0)
                }
            }
            .padding(.top, Theme.spacing.lg)

            if !item.me {
                Spacer(minLength: 55)
            }
        }
        .contentShape(.rect)
    }
}
