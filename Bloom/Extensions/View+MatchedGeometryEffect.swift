//
//  View+MatchedGeometryEffect.swift
//  Bloom
//
//  Created by Аскольд on 15.08.2026.
//

import SwiftUI

struct HeroMatchedModifier: ViewModifier {
    @Environment(\.heroNamespace) private var namespace
    
    let id: AnyHashable
    var isSource: Bool = true

    func body(content: Content) -> some View {
        if let namespace {
            content.matchedGeometryEffect(id: id, in: namespace, isSource: isSource)
        } else {
            content
        }
    }
}

extension View {
    func heroMatched(id: AnyHashable, isSource: Bool = true) -> some View {
        modifier(HeroMatchedModifier(id: id, isSource: isSource))
    }
}
