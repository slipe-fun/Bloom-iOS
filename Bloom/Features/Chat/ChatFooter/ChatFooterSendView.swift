//
//  ChatFooterSendView.swift
//  Bloom
//
//  Created by Аскольд on 13.08.2026.
//

import SwiftUI
import DequeModule

struct ChatFooterSendView: View {
    @Binding var text: String
    @Binding var barHeight: CGFloat
    @Binding var isRecordingLocked: Bool
    
    @Environment(MessagesStore.self) private var store
    
    @State private var isPressing: Bool = false
    @State private var holdTask: Task<Void, Never>? = nil
    
    var hasText: Bool {
        !text.trim().isEmpty
    }
    
    var body: some View {
        Button {
            if hasText {
                sendTextMessage()
            }
        } label: {
            ZStack {
                Image(systemName: "microphone.fill")
                    .font(.headline)
                    .foregroundStyle(.foreground.opacity(0.4))
                    .scaleEffect(hasText ? 0.5 : 1)
                    .opacity(hasText ? 0 : 1)
                
                Circle()
                    .fill(isRecordingLocked ? Color(.red).opacity(0.35) : Theme.colors.primary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .scaleEffect(isRecordingLocked ? 1 : hasText ? 1 : 0)
                    .opacity(isRecordingLocked ? 1 : hasText ? 1 : 0)
                    .blur(radius: isRecordingLocked ? 0 : hasText ? 0 : 6)
                
                if hasText {
                    Image(systemName: "arrow.up")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .transition(
                            .asymmetric(
                                insertion: .offset(y: 17).combined(with: .opacity).combined(with: .blur(radius: 3).combined(with: .scale(scale: 0.7))),
                                removal: .offset(y: -17).combined(with: .opacity).combined(with: .blur(radius: 3).combined(with: .scale(scale: 0.7)))
                            )
                        )
                }
            }
            .animation(.smooth(duration: 0.235), value: hasText)
        }
        .buttonStyle(InstantPressButtonStyle { pressing in
            guard !hasText else { return }
            isPressing = pressing
            if pressing {
                startHoldSequence()
            } else {
                cancelHoldSequence()
            }
        })
        .padding(barHeight == 44 ? Theme.spacing.xs + 2 : barHeight == 52 ? Theme.spacing.md - 2 : Theme.spacing.lg)
        .frame(width: barHeight + 2, height: barHeight + 2)
        .animation(.smooth(duration: 0.235), value: text)
    }
    
    private func startHoldSequence() {
        holdTask?.cancel()
        
        holdTask = Task { @MainActor in
            try? await Task.sleep(for: .seconds(0.15))
            guard !Task.isCancelled else { return }
            
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            withAnimation(.smooth(duration: 0.35)) {
                barHeight = 52
            }
            
            try? await Task.sleep(for: .seconds(0.75))
            guard !Task.isCancelled else { return }
            
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            withAnimation(.smooth(duration: 0.35)) {
                barHeight = 64
                isRecordingLocked = true
            }
        }
    }
    
    private func cancelHoldSequence() {
        holdTask?.cancel()
        holdTask = nil
        
        if !isRecordingLocked {
            withAnimation(.smooth(duration: 0.235)) {
                barHeight = 44
            }
        }
    }
    
    private func sendTextMessage() {
        let newMessage = MessageItem(
            id: (store.data.first?.id ?? 0) + 1,
            content: self.text,
            date: "12:00",
            me: Bool.random(),
            nonce: UUID().uuidString,
            chatId: 1,
            authorId: "user_1",
            groupEnd: true,
            groupStart: true
        )
        withAnimation(.smooth(duration: 0.235)) {
            store.data.prepend(newMessage)
        }
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(3.0))
            withAnimation(.smooth(duration: 0.235)) {
                store.lastSeenId = store.data.first?.id ?? 0
            }
        }
        self.text = ""
    }
}

struct InstantPressButtonStyle: ButtonStyle {
    var onPressingChanged: (Bool) -> Void
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .onChange(of: configuration.isPressed) { _, isPressed in
                onPressingChanged(isPressed)
            }
    }
}
