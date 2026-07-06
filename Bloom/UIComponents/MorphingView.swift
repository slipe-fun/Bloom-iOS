//
//  MorphingView.swift
//  Bloom
//
//  Created by Аскольд on 07.07.2026.
//

import SwiftUI

struct MorphingBlurModifier: ViewModifier, Animatable {
    var progress: Double
    var maxBlur: CGFloat
    var threshold: Float
    var smoothness: Float

    var animatableData: Double {
        get { progress }
        set { progress = newValue }
    }

    func body(content: Content) -> some View {
        let currentBlur = maxBlur * sin(progress * .pi)
        content
            .blur(radius: currentBlur)
            .colorEffect(
                ShaderLibrary.alphaThreshold(
                    .float(threshold),
                    .float(smoothness)
                )
            )
    }
}

struct MorphingView<ID: Hashable, Content: View>: View {
    private let currentID: ID
    @ViewBuilder private let content: (ID) -> Content

    private let blurRadius: CGFloat
    private let threshold: Float
    private let smoothness: Float
    private let transitionAnimation: Animation

    @State private var previousID: ID? = nil
    @State private var activeID: ID
    @State private var transitionProgress: Double = 1.0

    init(
        currentID: ID,
        blurRadius: CGFloat = 11,
        threshold: Float = 0.5,
        smoothness: Float = 0.1,
        animation: Animation = .slowSpring,
        @ViewBuilder content: @escaping (ID) -> Content
    ) {
        self.currentID = currentID
        self.blurRadius = blurRadius
        self.threshold = threshold
        self.smoothness = smoothness
        self.transitionAnimation = animation
        self.content = content
        self._activeID = State(initialValue: currentID)
    }

    var body: some View {
        ZStack {
            if let prevID = previousID, transitionProgress < 1.0 {
                content(prevID)
                    .opacity(1.0 - transitionProgress)
            }
            content(activeID)
                .opacity(transitionProgress)
        }
        .compositingGroup()
        .modifier(
            MorphingBlurModifier(
                progress: transitionProgress,
                maxBlur: blurRadius,
                threshold: threshold,
                smoothness: smoothness
            )
        )
        .onChange(of: currentID) { oldValue, newValue in
            guard oldValue != newValue else { return }

            previousID = oldValue
            activeID = newValue
            transitionProgress = 0.0

            withAnimation(transitionAnimation) {
                transitionProgress = 1.0
            } completion: {
                previousID = nil
            }
        }
    }
}
