//
//  AvatarGradient.swift
//  Bloom
//
//  Created by Аскольд on 27.06.2026.
//

import SwiftUI
import CryptoKit

func avatarGradient(for id: String) -> [Color] {
    var hash: Int = 5381
    
    for byte in id.utf8 {
        hash = 33 &* hash &+ Int(byte)
    }
    
    let index = abs(hash) % AvatarConstants.avatarColors.count
    
    return AvatarConstants.avatarColors[index]
}
