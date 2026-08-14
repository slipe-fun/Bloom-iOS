//
//  AuthMnemonicView.swift
//  Bloom
//
//  Created by Аскольд on 14.08.2026.
//

import SwiftUI

struct AuthMnemonicView: View {
    @Environment(AppState.self) private var appState
    @State private var words: [String] = Array(repeating: "", count: 12)
    @FocusState private var focusedIndex: Int?

    private var isComplete: Bool {
        words.allSatisfy { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
    }

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: Theme.spacing.md - 2) {
                        Text("Enter mnemonic")
                            .font(.system(size: 32, weight: .bold, design: .rounded))

                        Text("You need to enter 12 words of mnemonic phrase to log in")
                            .font(.system(.headline, design: .rounded, weight: .medium))
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 24)

                    AuthMnemonicInputView(words: $words, focusedIndex: $focusedIndex)
                }
                .padding(.horizontal, 36)
                .padding(.bottom, 24)
            }
            .scrollIndicators(.hidden)
            .scrollDismissesKeyboard(.interactively)
        }
        .safeAreaInset(edge: .bottom) {
            AuthMnemonicFooterView(isEnabled: isComplete)
        }
        .toolbarBackground(.hidden, for: .navigationBar)
        .scrollEdgeEffectHidden(true, for: .all)
        .topVariableBlur()
        .ignoresSafeArea(.container, edges: .bottom)
    }
}
