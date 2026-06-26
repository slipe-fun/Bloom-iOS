//
//  AnyTransition+Custom.swift
//  Bloom
//
//  Created by Аскольд on 27.06.2026.
//

import SwiftUI

struct BlurTransition: ViewModifier {
    let radius: CGFloat
    
    func body(content: Content) -> some View {
        content.blur(radius: radius)
    }
}

extension AnyTransition {
    static func blur(radius: CGFloat) -> AnyTransition {
        .modifier(active: BlurTransition(radius: radius), identity: BlurTransition(radius: 0))
    }
}
