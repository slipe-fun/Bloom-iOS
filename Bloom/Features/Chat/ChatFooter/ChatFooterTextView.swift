//
//  ChatFooterTextView.swift
//  Bloom
//
//  Created by Аскольд on 16.08.2026.
//

import SwiftUI

struct ChatFooterTextView: View {
    @FocusState.Binding var focused: Bool
    @Binding var text: String
    @Binding var inputBarHeight: CGFloat
    @Binding var isRecordingLocked: Bool
    
    private var isExpanded: Bool {
        inputBarHeight > 44
    }
    
    var body: some View {
        TextField(
            "",
            text: $text,
            prompt: Text("Type a message...")
                .font(.system(.headline, design: .rounded, weight: .medium))
                .foregroundStyle(.primary),
            axis: .vertical
        )
        .frame(maxWidth: .infinity, alignment: .leading)
        .lineLimit(1...5)
        .focused($focused)
        .font(.system(.headline, design: .rounded, weight: .medium))
        .padding(.leading, Theme.spacing.lg)
        .padding(.vertical, Theme.spacing.md)
        .foregroundStyle(.primary)
        .textFieldStyle(.plain)
        .tint(Theme.colors.primary)
        .opacity(isExpanded ? 0 : 1)
        
        ChatFooterSendView(
            text: $text,
            barHeight: $inputBarHeight,
            isRecordingLocked: $isRecordingLocked
        )
    }
}
