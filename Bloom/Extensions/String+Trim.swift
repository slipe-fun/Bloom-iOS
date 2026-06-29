//
//  String+Trim.swift
//  Bloom
//
//  Created by Аскольд on 29.06.2026.
//

extension String {
    func trim() -> String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
