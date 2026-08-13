//
//  ChatsListRowView.swift
//  Bloom
//
//  Created by Аскольд on 11.08.2026.
//

import SwiftUI

struct ChatsListRowView: View {
    let userId: Int

    var body: some View {
        HStack(alignment: .top, spacing: 0) {
                    AvatarView(
                        size: .lg,
                        id: String(userId),
                        name: String(userId)
                    )
                    .padding(.trailing, Theme.spacing.lg)
                    .padding(.vertical, Theme.spacing.md)

                    VStack(alignment: .center, spacing: Theme.spacing.sm) {
                        HStack(alignment: .firstTextBaseline, spacing: Theme.spacing.xs) {
                            Text("Test name")
                                .font(.system(.headline, design: .rounded, weight: .semibold))
                                .foregroundStyle(.primary)
                                .lineLimit(1)

                            Spacer(minLength: Theme.spacing.xs)

                            Text("11:11")
                                .font(.system(.footnote, design: .rounded, weight: .medium))
                                .foregroundStyle(.secondary)
                        }

                        HStack(alignment: .firstTextBaseline, spacing: Theme.spacing.xs) {
                            Text("Test last message")
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
                .background {
                    NavigationLink(value: Route.chat(id: userId)) {
                        EmptyView()
                    }
                    .opacity(0)
                }
        .buttonStyle(.plain)
        .contextMenu {
            Button {
            } label: {
                Label("Pin", systemImage: "pin.fill")
            }

            Button {
            } label: {
                Label("Mute", systemImage: "bell.slash.fill")
            }

            Divider()

            Button(role: .destructive) {
            } label: {
                Label("Delete chat", systemImage: "trash.fill")
            }
        } preview: {
            ChatPreviewView(userId: userId)
        }
    }
}

// MARK: - Представление предпросмотра чата

struct ChatPreviewView: View {
    let userId: Int
    
        private var previewWidth: CGFloat {
            let screenWidth = UIScreen.main.bounds.width
            return screenWidth - 32
        }

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.spacing.md) {
            Text("Chat with \(userId)")
                .font(.headline)

            Text("Last messages")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Spacer()
        }
        .padding()
        .frame(width: previewWidth, height: previewWidth * 1.25)
        .background(Theme.colors.background)
    }
}
