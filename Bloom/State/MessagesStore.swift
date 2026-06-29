//
//  MessagesStore.swift
//  Bloom
//
//  Created by Аскольд on 28.06.2026.
//

import SwiftUI
import Observation

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

struct IndexedMessageItem: Identifiable, Hashable, Sendable {
    let index: Int
    let element: MessageItem
    
    var id: Int { element.id }
}

@Observable
@MainActor
final class MessagesListStore {
    var data: [MessageItem] = [] {
        didSet {
            self.indexedItems = data.enumerated().map {
                IndexedMessageItem(index: $0.offset, element: $0.element)
            }
        }
    }
    
    private(set) var indexedItems: [IndexedMessageItem] = []
    var lastSeenId: Int = 0
}
