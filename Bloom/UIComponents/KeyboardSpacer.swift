//
//  KeyboardSpacer.swift
//  Bloom
//
//  Created by Аскольд on 23.06.2026.
//
import SwiftUI

struct KeyboardSpacer: View {
    @State private var keyboardHeight: CGFloat = 0

    var body: some View {
        Color.clear
            .frame(height: keyboardHeight)
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { notification in
                if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                    withAnimation(.quickSpring) {
                        self.keyboardHeight = keyboardFrame.height - 16
                    }
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                withAnimation(.quickSpring) {
                    self.keyboardHeight = 0
                }
            }
    }
}
