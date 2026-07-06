//
//  DashedBoxView.swift
//  Bloom
//
//  Created by Аскольд on 07.07.2026.
//

import SwiftUI

public struct DashedBoxView<Content: View>: View {
    public let width: CGFloat
    public let height: CGFloat
    public let borderRadius: CGFloat
    public let dashLength: CGFloat
    public let gapLength: CGFloat
    public let strokeWidth: CGFloat
    public let color: Color
    public let durationMs: Double
    @ViewBuilder public let content: () -> Content
    
    @State private var dashOffset: CGFloat = 0
    
    public init(
        width: CGFloat,
        height: CGFloat,
        borderRadius: CGFloat = 26,
        dashLength: CGFloat = 15,
        gapLength: CGFloat = 15,
        strokeWidth: CGFloat = 4,
        color: Color = .black,
        durationMs: Double = 1500,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.width = width
        self.height = height
        self.borderRadius = borderRadius
        self.dashLength = dashLength
        self.gapLength = gapLength
        self.strokeWidth = strokeWidth
        self.color = color
        self.durationMs = durationMs
        self.content = content
    }
    
    private var rectWidth: CGFloat {
        max(0, width - strokeWidth)
    }
    
    private var rectHeight: CGFloat {
        max(0, height - strokeWidth)
    }
    
    private var patternData: (actualDash: CGFloat, actualGap: CGFloat, actualPattern: CGFloat) {
        let maxRadius = min(rectWidth / 2, rectHeight / 2)
        let r = max(0, min(borderRadius, maxRadius))
        
        let perimeter = 2 * (rectWidth - 2 * r) + 2 * (rectHeight - 2 * r) + 2 * .pi * r
        let desiredPattern = dashLength + gapLength
        
        guard desiredPattern > 0, perimeter > 0 else {
            return (0, 0, 0)
        }
        
        let dashCount = max(1.0, round(perimeter / desiredPattern))
        let pattern = perimeter / dashCount
        
        let actualDash = pattern * (dashLength / desiredPattern)
        let actualGap = pattern * (gapLength / desiredPattern)
        
        return (actualDash, actualGap, pattern)
    }
    
    public var body: some View {
        let data = patternData
        let r = min(borderRadius, min(rectWidth / 2, rectHeight / 2))
        
        ZStack {
            RoundedRectangle(cornerRadius: r)
                .stroke(
                    color,
                    style: StrokeStyle(
                        lineWidth: strokeWidth,
                        lineCap: .round,
                        dash: [data.actualDash, data.actualGap],
                        dashPhase: dashOffset
                    )
                )
                .frame(width: rectWidth, height: rectHeight)
            
            content()
        }
        .frame(width: width, height: height)
        .id(data.actualPattern)
        .onAppear {
            dashOffset = 0
            let durationSeconds = durationMs / 1000.0
            
            withAnimation(
                .linear(duration: durationSeconds)
                .repeatForever(autoreverses: false)
            ) {
                dashOffset = -data.actualPattern
            }
        }
    }
}
