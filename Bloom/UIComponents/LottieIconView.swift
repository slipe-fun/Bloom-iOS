//
//  LottieIconView.swift
//  Bloom
//
//  Created by Аскольд on 24.06.2026.
//

import SwiftUI
import Lottie

struct CustomLottieView: View {
    let source: String
    let loop: Bool
    let autoPlay: Bool
    let size: CGFloat
    let color: Color
    
    private var playbackMode: LottiePlaybackMode {
        if autoPlay {
            return .playing(.fromProgress(0, toProgress: 1, loopMode: loop ? .loop : .playOnce))
        } else {
            return .paused(at: .progress(0))
        }
    }

    var body: some View {
        LottieView(animation: .named(source))
            .playbackMode(playbackMode)
            .valueProvider(
                ColorValueProvider(color.lottieColor),
                for: AnimationKeypath(keypath: "**.Primary.**.Color")
            )
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
    }
}
