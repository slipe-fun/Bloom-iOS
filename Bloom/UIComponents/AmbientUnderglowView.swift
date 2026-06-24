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
                let elapsed = timeline.date.timeIntervalSince(startDate)
                
                autoreleasepool {
                    let sizeArg = Shader.Argument.float2(frameSize)
                    let timeArg = Shader.Argument.float(Float(elapsed))
                    let progressArg = Shader.Argument.float(Float(animationProgress))
                    let colorArg = Shader.Argument.color(tintColor)
                    let partColorArg = Shader.Argument.color(particleColor)
                    
                    let underglowShader = ShaderLibrary.ambientUnderglow(
                        sizeArg,
                        timeArg,
                        progressArg,
                        colorArg,
                        partColorArg
                    )
                    return Rectangle()
                        .fill(Color.black)
                        .colorEffect(
                            underglowShader
                        )
                }
            }
        }
    }
}
