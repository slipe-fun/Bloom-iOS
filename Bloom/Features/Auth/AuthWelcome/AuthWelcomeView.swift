//
//  AuthWelcomeView.swift
//  Bloom
//
//  Created by Аскольд on 14.08.2026.
//

import SwiftUI

struct AuthWelcomeView: View {
    
    @Binding var path: NavigationPath
    @State private var appeared = false
    @State private var rotation: Double = 0

    var body: some View {
        VStack {
            Spacer()

            VStack(spacing: Theme.spacing.xxl) {

                Button {
                    withAnimation(.snappy(duration: 0.35, extraBounce: 0.25)) {
                        rotation += 90
                    }
                } label: {
                    Image("GiantLogo")
                        .resizable()
                        .scaledToFit()
                        .rotationEffect(.degrees(rotation))
                        .frame(width: 128, height: 128)
                        .background(.foreground)
                        .clipShape(RoundedRectangle(cornerRadius: 32))
                }
                .buttonStyle(ScaleButtonStyle(appeared: appeared))
                .opacity(appeared ? 1 : 0)
                .blur(radius: appeared ? 0 : 8)
                VStack(spacing: Theme.spacing.md - 2) {
                    HStack(spacing: 0) {
                        Text("This is ")
                        Text("Bloom")
                            .fontWeight(.black)
                    }
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 16)
                    .blur(radius: appeared ? 0 : 8)
                    .animation(
                        .smooth(duration: 0.75).delay(0.08),
                        value: appeared
                    )

                    Text("End-to-end encrypted messenger with seamless experience")
                        .font(.system(.headline, design: .rounded, weight: .medium))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .opacity(appeared ? 1 : 0)
                        .offset(y: appeared ? 0 : 16)
                        .blur(radius: appeared ? 0 : 8)
                        .animation(
                            .smooth(duration: 0.75).delay(0.16),
                            value: appeared
                        )
                }
                }

            Spacer()
        }
        .padding(.horizontal, 36)
        .safeAreaInset(edge: .bottom) {
            AuthWelcomeFooterView(appeared: appeared, path: $path)
        }
        .ignoresSafeArea(.container, edges: .bottom)
        .onAppear {
            withAnimation(.snappy(duration: 0.75)) {
                appeared = true
            }
        }
    }
}

struct ScaleButtonStyle: ButtonStyle {
    let appeared: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(
                appeared
                    ? (configuration.isPressed ? 0.9 : 1.0)
                    : 0.9
            )
            .animation(.snappy(duration: 0.35, extraBounce: 0.25), value: configuration.isPressed)
    }
}
