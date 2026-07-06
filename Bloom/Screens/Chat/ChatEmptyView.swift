//
//  ChatEmptyView.swift
//  Bloom
//
//  Created by Аскольд on 07.07.2026.
//

import SwiftUI

enum MorphState: String, CaseIterable, Identifiable {
    case message = "message_icon"
    case faceSmile = "face.smile_icon"
    case image = "image_icon"
    case stae = "star_icon"
    
    var id: String { self.rawValue }
}

struct ChatEmptyView: View {
    @Environment(\.customSafeArea) private var safeArea
    @State private var currentState: MorphState = .message
    @State private var lastInteractionDate = Date()
    
    let keyboardHeight: CGFloat
    
    let highlighted = Text("Hi!")
        .font(Theme.font.headline)
        .foregroundStyle(Theme.colors.primary)
    
    private func selectNextState() {
        let allStates = MorphState.allCases
        if let currentIndex = allStates.firstIndex(of: currentState) {
            let nextIndex = (currentIndex + 1) % allStates.count
            currentState = allStates[nextIndex]
        }
    }
    
    private func handleTap() {
        selectNextState()
        
        lastInteractionDate = Date()
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: Theme.spacing.lg) {
            DashedBoxView(width: 105, height: 105, borderRadius: Theme.radius.xl, dashLength: 10, color: Theme.colors.switcher) {
                MorphingView(currentID: currentState) { state in
                    IconView(name: state.rawValue, size: 70, color: Theme.colors.switcher)
                }
                .frame(width: 100, height: 100)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                handleTap()
            }
            
            VStack(alignment: .center, spacing: Theme.spacing.sm) {
                Text("Chats seems empty")
                    .font(Theme.font.title2Thinner)
                    .foregroundStyle(Theme.colors.text)
                
                Text("Say \(highlighted) to start the conversation")
                    .font(Theme.font.body)
                    .foregroundStyle(Theme.colors.secondaryText)
                    .tint(Theme.colors.primary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .offset(y: min(0, (-keyboardHeight + safeArea.top) / 2))
        .transition(.blur(radius: 8).combined(with: .opacity).combined(with: .scale(scale: 0.9)))
        .task(id: lastInteractionDate) {
            do {
                try await Task.sleep(for: .seconds(3))
                
                selectNextState()
                
                lastInteractionDate = Date()
            } catch {
                
            }
        }
    }
}
