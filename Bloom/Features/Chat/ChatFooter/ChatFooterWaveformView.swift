//
//  ChatFooterWaveformView.swift
//  Bloom
//
//  Created by Аскольд on 16.08.2026.
//

import SwiftUI
import BlurSwiftUI
import BlurUIKit

private struct WaveBarItem: View {
    let targetHeight: CGFloat
    let minHeight: CGFloat
    let barWidth: CGFloat
    let color: Color

    @State private var isAppeared = false

    var body: some View {
        Capsule()
            .fill(color)
            .frame(width: barWidth, height: isAppeared ? targetHeight : minHeight)
            .frame(maxHeight: .infinity, alignment: .center)
            .opacity(isAppeared ? 1.0 : 0.0)
            .onAppear {
                withAnimation(.easeOut(duration: 0.25)) {
                    isAppeared = true
                }
            }
    }
}

struct ChatFooterWaveformView: View {
    var samples: [AudioSample]

    var waveColor: Color = Theme.colors.red
    var barWidth: CGFloat = 2.2
    var barSpacing: CGFloat = 2.2
    var minBarHeight: CGFloat = 6.0
    var maxBarHeight: CGFloat = 36.0

    var body: some View {
        GeometryReader { geometry in
            let totalBarSpace = barWidth + barSpacing
            let maxBars = max(1, Int(geometry.size.width / totalBarSpace))
            let visibleSamples = samples.suffix(maxBars)
            let placeholderCount = max(0, maxBars - visibleSamples.count)

            ZStack(alignment: .center) {
                waveformContent(visibleSamples: visibleSamples, placeholderCount: placeholderCount, blurred: true)
                    .blur(radius: 8)
                    .opacity(0.45)

                waveformContent(visibleSamples: visibleSamples, placeholderCount: placeholderCount, blurred: false)
            }
            .mask(
                LinearGradient(
                    stops: [
                        .init(color: .clear, location: 0.0),
                        .init(color: .black, location: 0.235),
                        .init(color: .black, location: 1.0)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .overlay(alignment: .leading) {
                VariableBlur(direction: .left)
                    .maximumBlurRadius(1)
                    .passesTouchesThrough(true)
                    .dimmingTintColor(.clear)
                    .frame(width: 54)
                    .frame(maxHeight: .infinity)
            }
        }
    }

    @ViewBuilder
    private func waveformContent(visibleSamples: ArraySlice<AudioSample>, placeholderCount: Int, blurred: Bool) -> some View {
        HStack(alignment: .center, spacing: barSpacing) {
            ForEach(0..<placeholderCount, id: \.self) { _ in
                Capsule()
                    .fill(waveColor)
                    .frame(width: barWidth, height: minBarHeight)
                    .frame(maxHeight: .infinity, alignment: .center)
                    .opacity(blurred ? 0.0 : 0.5)
            }

            ForEach(visibleSamples) { sample in
                WaveBarItem(
                    targetHeight: max(minBarHeight, sample.value * maxBarHeight),
                    minHeight: minBarHeight,
                    barWidth: barWidth,
                    color: blurred ? Color(red: 1.0, green: 0.0, blue: 0.0) : waveColor
                )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}
