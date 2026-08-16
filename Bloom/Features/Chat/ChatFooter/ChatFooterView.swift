//
//  ChatFooterView.swift
//  Bloom
//
//  Created by Аскольд on 12.08.2026.
//

import SwiftUI
import PhotosUI

struct ChatFooterView: View {
    @State private var text: String = ""
    @FocusState private var focused: Bool
    @State private var isKeyboardVisible = false
    
    @State private var selectedPhotoItem: PhotosPickerItem? = nil
    
    @State private var inputBarHeight: CGFloat = 44
    @State private var isRecordingLocked: Bool = false
    
    @Namespace private var glassNamespace
    
    private var isExpanded: Bool {
        inputBarHeight > 44
    }
    
    var body: some View {
        GlassEffectContainer(spacing: Theme.spacing.md) {
            HStack(alignment: .bottom, spacing: Theme.spacing.md) {
                
                if !isExpanded {
                    PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                        Image(systemName: "plus")
                            .foregroundStyle(.primary)
                            .font(.title3)
                            .frame(width: 44, height: 44)
                    }
                    .buttonStyle(.plain)
                    .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 22))
                    .glassEffectID("actionButton", in: glassNamespace)
                    .glassEffectTransition(.matchedGeometry)
                }
                
                HStack(alignment: .bottom, spacing: Theme.spacing.xs) {
                    if isExpanded {
                        ChatFooterVoiceView(isRecordingLocked: isRecordingLocked)
                            .transition(.blurReplace)
                    } else {
                        ChatFooterTextView(focused: $focused, text: $text, inputBarHeight: $inputBarHeight, isRecordingLocked: $isRecordingLocked)
                            .transition(.blurReplace)
                    }
                }
                .clipShape(Capsule())
                .frame(maxWidth: .infinity)
                .frame(height: isExpanded ? inputBarHeight : nil)
                .frame(minHeight: 44)
                .glassEffect(
                    .regular.interactive(),
                    in: RoundedRectangle(cornerRadius: inputBarHeight / 2)
                )
                .glassEffectID("inputField", in: glassNamespace)
                .onTapGesture {
                    self.focused = true
                }
            }
            .frame(maxWidth: .infinity)
        }
        .animation(.smooth(duration: 0.35), value: isExpanded)
        .animation(.smooth(duration: 0.35), value: inputBarHeight)
        .animation(.smooth(duration: 0.235), value: text)
        .padding(.horizontal, isKeyboardVisible ? Theme.spacing.lg : Theme.spacing.xxxl)
        .padding(.top, Theme.spacing.md)
        .padding(.bottom, isKeyboardVisible ? Theme.spacing.lg : Theme.spacing.xxxl)
        .animation(.smooth(duration: 0.235), value: isKeyboardVisible)
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
        .onChange(of: selectedPhotoItem) { _, newItem in
            if let newItem {
                handleSelectedPhoto(newItem)
            }
        }
    }
    
    private func handleSelectedPhoto(_ item: PhotosPickerItem) {
    }
}
