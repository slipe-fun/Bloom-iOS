//
//  ChatsListRowView.swift
//  Bloom
//
//  Created by Аскольд on 11.08.2026.
//

import SwiftUI

struct ChatsListRowView: View {
    let userId: Int
    @Environment(MessagesStore.self) private var store

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
            Section {
                Button {
                    print("mute")
                } label: {
                    Label("Mute", systemImage: "speaker.slash.fill")
                        .fontDesign(.rounded)
                        .fontWeight(.medium)
                }
                
                Button {
                    print("pin")
                } label: {
                    Label("Pin chat", systemImage: "pin.fill")
                        .fontDesign(.rounded)
                        .fontWeight(.medium)
                }
            }
            
            Section {
                Button(role: .destructive) {
                    print("clear messages")
                } label: {
                    Label("Clear messages", systemImage: "trash.fill")
                        .fontDesign(.rounded)
                        .fontWeight(.medium)
                }
                
                Button(role: .destructive) {
                    print("block user")
                } label: {
                    Label("Block user", systemImage: "person.crop.circle.badge.xmark")
                        .fontDesign(.rounded)
                        .fontWeight(.medium)
                }
            }
        } preview: {
            ChatPreviewView(userId: userId, store: store)
        }
        .swipeActions(edge: .leading, allowsFullSwipe: true) {
            Button {
                // Pin here
            } label: {
                 Image(systemName: "pin.fill")
            }
            .tint(.orange)
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                // Delete here
            } label: {
                 Image(systemName: "trash.fill")
            }
            
            Button {
                // Mute here
            } label: {
                 Image(systemName: "speaker.slash.fill")
            }
            .tint(.indigo)
        }
    }
}
