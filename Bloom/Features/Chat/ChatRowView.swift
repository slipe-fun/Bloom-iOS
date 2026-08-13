//
// ChatRowView.swift
// Bloom
//
// Created by Аскольд on 13.08.2026.
//

import SwiftUI

struct ChatRowView: View, Equatable {
    let item: MessageItem
    let isSeen: Bool

    var onCopy: (Int) -> Void = { _ in }
    var onReply: (Int) -> Void = { _ in }
    var onForward: (Int) -> Void = { _ in }
    var onDelete: (Int) -> Void = { _ in }

    static func == (lhs: ChatRowView, rhs: ChatRowView) -> Bool {
        lhs.item.id == rhs.item.id &&
        lhs.item.content == rhs.item.content &&
        lhs.isSeen == rhs.isSeen &&
        lhs.item.me == rhs.item.me
    }

    private enum Layout {
        static let bubbleCornerRadius: CGFloat = 22
        static let emojiOverlayCornerRadius: CGFloat = 20
        static let minBubbleWidth: CGFloat = 60
        static let minBubbleHeight: CGFloat = 40
        static let sideSpacer: CGFloat = 55
        static let minEmojiSize: CGFloat = 32
    }

    private var textColor: Color {
        item.me ? Theme.colors.white : Theme.colors.text
    }

    private var backgroundColor: Color {
        item.me ? Theme.colors.primary : Color(.secondarySystemBackground)
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

        return max(Layout.minEmojiSize, size)
    }

    @ViewBuilder
    private var messageBubble: some View {
        let invisibleSpaceForTime = Text("\u{00A0}\u{00A0}" + item.date)
            .font(.system(.footnote, design: .rounded, weight: .regular))
            .foregroundColor(.clear)

        if item.content.isOnlyEmojis {
            Text(item.content)
                .font(.system(size: emojiSize, weight: .regular, design: .rounded))
                .padding(.bottom, item.content.isSingleEmoji ? 0 : Theme.spacing.xxl)
                .overlay(
                    Text(item.date)
                        .font(.system(.footnote, design: .rounded, weight: .regular))
                        .foregroundColor(Theme.colors.text)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: Layout.emojiOverlayCornerRadius)),
                    alignment: item.me ? .bottomTrailing : .bottomLeading
                )
        } else {
            Text("\(item.content)\(invisibleSpaceForTime)")
                .font(.system(.headline, design: .rounded, weight: .regular))
                .foregroundColor(textColor)
                .padding(.horizontal, 15)
                .padding(.vertical, 11)
                .frame(minWidth: Layout.minBubbleWidth, minHeight: Layout.minBubbleHeight, alignment: .leading)
                .background(backgroundColor, in: RoundedRectangle(cornerRadius: Layout.bubbleCornerRadius))
                .overlay(
                    Text(item.date)
                        .font(.system(.footnote, design: .rounded, weight: .regular))
                        .foregroundColor(textColor.opacity(0.5))
                        .padding(.trailing, 13)
                        .padding(.bottom, 9),
                    alignment: .bottomTrailing
                )
        }
    }

    private var contextMenuActions: [ContextMenuAction] {
        var actions: [ContextMenuAction] = [
            ContextMenuAction(title: "Копировать", systemImage: "doc.on.doc") {
                onCopy(item.id)
            },
            ContextMenuAction(title: "Ответить", systemImage: "arrowshape.turn.up.left") {
                onReply(item.id)
            },
            ContextMenuAction(title: "Переслать", systemImage: "arrowshape.turn.up.right") {
                onForward(item.id)
            }
        ]

        if item.me {
            actions.append(
                ContextMenuAction(title: "Удалить", systemImage: "trash", isDestructive: true) {
                    onDelete(item.id)
                }
            )
        }

        return actions
    }

    var body: some View {
        HStack {
            if item.me {
                Spacer(minLength: Layout.sideSpacer)
            }

            VStack(alignment: item.me ? .trailing : .leading, spacing: 0) {
                messageBubble
                    .uiKitContextMenu(
                        cornerRadius: Layout.bubbleCornerRadius,
                        actions: contextMenuActions
                    ) {
                        messageBubble
                    }

                if item.me {
                    Text("Read")
                        .font(.system(.subheadline, design: .rounded, weight: .regular))
                        .foregroundColor(.secondary)
                        .padding(.top, isSeen ? Theme.spacing.sm : 0)
                        .frame(height: isSeen ? nil : 0, alignment: .top)
                        .opacity(isSeen ? 1 : 0)
                }
            }
            .padding(.top, Theme.spacing.lg)

            if !item.me {
                Spacer(minLength: Layout.sideSpacer)
            }
        }
        .contentShape(.rect)
    }
}
