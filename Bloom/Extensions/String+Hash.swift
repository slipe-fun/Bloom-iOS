//
//  String+Hash.swift
//  Bloom
//
//  Created by Аскольд on 19.06.2026.
//

import Foundation

extension String {
    var hashCode: Int {
        var hash: Int32 = 0
        for scalar in self.unicodeScalars {
            let charValue = Int32(scalar.value)
            hash = (hash << 5) &- hash &+ charValue
        }
        return abs(Int(hash))
    }
}
