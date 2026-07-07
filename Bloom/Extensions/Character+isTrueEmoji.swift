//
//  Character+isTrueEmoji.swift
//  Bloom
//
//  Created by Аскольд on 07.07.2026.
//

import Foundation

extension Character {
    var isTrueEmoji: Bool {
        guard let firstScalar = unicodeScalars.first else { return false }
        
        return firstScalar.properties.isEmoji &&
        (firstScalar.properties.isEmojiPresentation || unicodeScalars.contains { $0.value == 0xFE0F })
    }
}
