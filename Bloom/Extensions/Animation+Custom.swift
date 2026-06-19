//
//  Animation+Custom.swift
//  Bloom
//
//  Created by Аскольд on 19.06.2026.
//

import SwiftUI

extension Animation {
    static var quickSpring: Animation {
        .interpolatingSpring(
            mass: 0.2,
            stiffness: 120.0,
            damping: 12.0,
            initialVelocity: 0.0
        )
    }
    static var springy: Animation {
        .interpolatingSpring(
            mass: 0.2,
            stiffness: 67.712,
            damping: 3.5,
            initialVelocity: 0.0
        )
    }
}
