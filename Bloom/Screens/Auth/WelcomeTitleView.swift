//
//  WelcomeTitleView.swift
//  Bloom
//
//  Created by Аскольд on 24.06.2026.
//

import SwiftUI

struct WelcomeTitleView: View {
        @State private var hoveredIndex: Int? = nil
        @State private var itemFrames: [Int: CGRect] = [:]
        @State private var isAppeared = false
    
        private let containerSpace = "CharacterContainer"
        private let items = ["B", "L", "👀", "M", "!"]
        
        var body: some View {
            VStack(alignment: .center, spacing: Theme.spacing.sm) {
                HStack(spacing: 0) {
                    ForEach(0..<items.count, id: \.self) { index in
                        Text(items[index])
                            .font(Theme.font.superTitle)
                            .foregroundStyle(Theme.colors.text)
                            .scaleEffect(hoveredIndex == nil ? 1.0 : (hoveredIndex == index ? 1.35 : 0.8))
                            .opacity(hoveredIndex == nil ? 1.0 : (hoveredIndex == index ? 1.0 : 0.5))
                            .blur(radius: hoveredIndex == nil ? 0 : (hoveredIndex == index ? 0 : 8))
                            .zIndex(hoveredIndex == index ? 1 : 0)
                            .lineSpacing(Theme.lineSpacing.md)
                            .animation(.springy, value: hoveredIndex)
                            .background(
                                GeometryReader { geo in
                                    Color.clear
                                        .onAppear {
                                            itemFrames[index] = geo.frame(in: .named(containerSpace))
                                        }
                                        .onChange(of: geo.frame(in: .named(containerSpace))) { _, newFrame in
                                            itemFrames[index] = newFrame
                                        }
                                }
                            )
                            .sensoryFeedback(.selection, trigger: hoveredIndex)
                    }
                }
                .coordinateSpace(name: containerSpace)
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            updateHoveredIndex(at: value.location)
                        }
                        .onEnded { _ in
                            hoveredIndex = nil
                        }
                )
                
                Text("🔒 Secured as Bank, ☎️ Simple as SMS and 🏎 Fast as Formula 1")
                    .font(Theme.font.headBody)
                    .foregroundColor(Theme.colors.secondaryText)
                    .multilineTextAlignment(.center)
                    .scaleEffect(hoveredIndex == nil ? 1.0 : 0.9)
                    .opacity(hoveredIndex == nil ? 1.0 : 0.5)
                    .blur(radius: hoveredIndex == nil ? 0 : 8)
                    .animation(.springy, value: hoveredIndex)
                    .lineSpacing(Theme.lineSpacing.md)
            }
            .opacity(isAppeared ? 1.0 : 0.0)
            .offset(y: isAppeared ? 0 : 40)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, Theme.spacing.xxxl + 8)
            .onAppear {
                withAnimation(.smooth(duration: 0.3)) {
                    isAppeared = true
                }
            }
        }
        
        private func updateHoveredIndex(at location: CGPoint) {
            for (index, frame) in itemFrames {
                if frame.contains(location) {
                    if hoveredIndex != index {
                        hoveredIndex = index
                    }
                    return
                }
            }
            hoveredIndex = nil
        }
}
