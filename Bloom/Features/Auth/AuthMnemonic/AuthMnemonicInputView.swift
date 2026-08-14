//
//  AuthMnemonicInputView.swift
//  Bloom
//
//  Created by Аскольд on 14.08.2026.
//

import SwiftUI

struct AuthMnemonicInputView: View {
    @Binding var words: [String]
    var focusedIndex: FocusState<Int?>.Binding

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(0..<words.count, id: \.self) { index in
                MnemonicField(
                    index: index,
                    text: $words[index],
                    focusedIndex: focusedIndex,
                    totalCount: words.count
                )
                .id(index)
            }
        }
    }
}

private struct MnemonicField: View {
    let index: Int
    @Binding var text: String
    var focusedIndex: FocusState<Int?>.Binding
    let totalCount: Int

    private var isFocused: Bool {
        focusedIndex.wrappedValue == index
    }

    private var isNumberHighlighted: Bool {
        isFocused || !text.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        HStack(spacing: 8) {
            TextField("", text: $text)
                .focused(focusedIndex, equals: index)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .keyboardType(.asciiCapable)
                .foregroundStyle(.primary)
                .font(.system(.headline, design: .rounded, weight: .medium))
                .submitLabel(index < totalCount - 1 ? .next : .done)
                .onSubmit {
                    if index < totalCount - 1 {
                        focusedIndex.wrappedValue = index + 1
                    } else {
                        focusedIndex.wrappedValue = nil
                    }
                }

            Spacer(minLength: 0)

            Text("\(index + 1)")
                .font(.system(.title3, design: .rounded, weight: .semibold))
                .foregroundStyle(isNumberHighlighted ? Color.primary : Color.secondary)
        }
        .padding(.horizontal, 16)
        .frame(height: 48)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color(.secondarySystemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(isFocused ? Color.primary.opacity(0.35) : Color.clear, lineWidth: 2)
        )
        .contentShape(RoundedRectangle(cornerRadius: 18))
        .onTapGesture {
            focusedIndex.wrappedValue = index
        }
        .animation(.smooth(duration: 0.235), value: isFocused)
        .animation(.smooth(duration: 0.235), value: isNumberHighlighted)
    }
}
