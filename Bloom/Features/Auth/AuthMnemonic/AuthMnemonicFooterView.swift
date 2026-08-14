//
//  AuthMnemonicFooterView.swift
//  Bloom
//
//  Created by Аскольд on 14.08.2026.
//

import SwiftUI

struct AuthMnemonicFooterView: View {
    let isEnabled: Bool
    let isLoading: Bool
    let action: () -> Void
    
    @State private var isKeyboardVisible = false

    var body: some View {
        VStack(spacing: 16) {
            Button(action: action) {
                HStack(spacing: 8) {
                    if isLoading {
                        ProgressView()
                            .tint(isEnabled ? .white : .primary)
                    }
                    Text("Continue")
                }
                .font(.system(.headline, design: .rounded, weight: .semibold))
                .foregroundStyle(isEnabled ? .white : .primary)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .contentShape(Capsule())
            }
            .buttonStyle(.plain)
            .disabled(!isEnabled)
            .glassEffect(
                .regular
                    .interactive()
                    .tint(isEnabled ? Theme.colors.primary.opacity(0.85) : Color.clear)
            )
        }
        .padding(.horizontal, isKeyboardVisible ? Theme.spacing.lg : 36)
        .padding(.top, 16)
        .padding(.bottom, isKeyboardVisible ? Theme.spacing.lg : 36)
        .animation(.smooth(duration: 0.235), value: isKeyboardVisible)
        .animation(.smooth(duration: 0.235), value: isEnabled)
        .background(
            LinearGradient(
                colors: [
                    Color(.systemBackground).opacity(0.8),
                    Color(.systemBackground).opacity(0.45),
                    Color(.systemBackground).opacity(0)
                ],
                startPoint: .bottom,
                endPoint: .top
            )
            .frame(height: isKeyboardVisible ? 0 : nil)
        )
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
            isKeyboardVisible = true
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            isKeyboardVisible = false
        }
    }
}
