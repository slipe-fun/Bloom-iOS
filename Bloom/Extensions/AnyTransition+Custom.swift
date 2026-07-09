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

struct RotateTransition: ViewModifier {
    let rotation: Double
    
    func body(content: Content) -> some View {
        content.rotationEffect(.degrees(rotation))
    }
}

extension AnyTransition {
    static func blur(radius: CGFloat) -> AnyTransition {
        .modifier(active: BlurTransition(radius: radius), identity: BlurTransition(radius: 0))
    }
    
    static func rotationEffect(degress: Double) -> AnyTransition {
        .modifier(active: RotateTransition(rotation: degress), identity: RotateTransition(rotation: 0))
    }
}
