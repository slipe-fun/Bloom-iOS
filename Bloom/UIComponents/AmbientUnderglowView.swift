//
//  AmbientUnderglowView.swift
//  Bloom
//
//  Created by Аскольд on 25.06.2026.
//

import SwiftUI

struct AmbientUnderglowView: View {
    var tintColor: Color = Theme.colors.primary
    var particleColor: Color = Theme.colors.primary
    var animationProgress: CGFloat = 1.0
    
    @State private var startDate = Date()

    var body: some View {
        GeometryReader { geometry in
            let frameSize = geometry.size
            
            TimelineView(.animation) { timeline in
                let elapsed = Float(timeline.date.timeIntervalSince(startDate))
                
                Color.black
                    .colorEffect(
                        ShaderLibrary.ambientUnderglow(
                            .float2(frameSize),
                            .float(elapsed),
                            .float(Float(animationProgress)),
                            .color(tintColor),
                            .color(particleColor)
                        )
                    )
            }
        }
    }
}
