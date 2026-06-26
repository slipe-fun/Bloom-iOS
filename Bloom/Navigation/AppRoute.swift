//
//  AppRoute.swift
//  Bloom
//
//  Created by Аскольд on 20.06.2026.
//

import Foundation

enum AppRoute: Hashable {
    case welcome
    case chats
    case chatDetail(chatId: Int)
    case settings
}
