//
//  String+Custom.swift
//  Bloom
//
//  Created by Аскольд on 13.08.2026.
//

import Foundation

extension String {
    func trim() -> String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var isOnlyEmojis: Bool {
        guard !isEmpty else { return false }
        
        let textToEvaluate = self
        
        return textToEvaluate.allSatisfy { $0.isTrueEmoji }
    }
    
    var isSingleEmoji: Bool {
        return count == 1 && isOnlyEmojis
    }
}
