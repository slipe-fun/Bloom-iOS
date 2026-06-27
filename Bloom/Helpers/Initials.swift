//
//  Initials.swift
//  Bloom
//
//  Created by Аскольд on 27.06.2026.
//

func initials(from name: String) -> String {
    let parts = name.split(separator: " ")
    
    let initials = parts.prefix(2).compactMap { $0.first }
    
    return String(initials).uppercased()
}
