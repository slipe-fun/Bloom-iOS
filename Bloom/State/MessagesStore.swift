//
//  MessagesStore.swift
//  Bloom
//
//  Created by Аскольд on 13.08.2026.
//

import SwiftUI
import Observation
import DequeModule

struct MessageItem: Identifiable, Hashable, Sendable {
    let id: Int
    let content: String
    let date: String
    let me: Bool
    let nonce: String
    let chatId: Int
    let authorId: String
    let groupEnd: Bool
    let groupStart: Bool
}

@Observable
@MainActor
final class MessagesStore {
    var data: Deque<MessageItem> = []
    var lastSeenId: Int = 0
}
