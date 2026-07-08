//
//  ChatsFooterView.swift
//  Bloom
//
//  Created by Аскольд on 22.06.2026.
//

import SwiftUI

struct ChatsFooterView: View {
    @Environment(SearchStore.self) private var store
    @Environment(BottomSheetManager.self) private var bottomSheetManager
    @FocusState private var isFocused: Bool
    
    let keyboardHeight: CGFloat
    let footerHeight: CGFloat
    let isKeyboardVisible: Bool
    
    var body: some View {
        GlassEffectContainer {
            HStack(spacing: Theme.spacing.md) {
                HStack(spacing: Theme.spacing.sm) {
                    IconView(name: "magnifyingglass_icon", size: 22, color: store.search ? Theme.colors.text : Theme.colors.secondaryText)
                    
                    @Bindable var bindableStore = store
                    
                    TextField(
                        "",
                        text: $bindableStore.searchValue,
                        prompt:
                            Text("Search chats")
                            .font(Theme.font.body)
                            .foregroundStyle(Theme.colors.secondaryText)
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentShape(Rectangle())
                    .focused($isFocused)
                    .font(Theme.font.body)
                    .padding(.trailing, Theme.spacing.md)
                    .foregroundStyle(Theme.colors.text)
                    .textFieldStyle(.plain)
                    .tint(Theme.colors.primary)
                    .onChange(of: isFocused) { _, newValue in
                        if newValue { store.setSearch(true) }
                    }
                }
                .padding(.leading, Theme.spacing.md)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .glassEffect(.clear.interactive().tint(Theme.colors.glassBackdrop))
                .contentShape(Rectangle())
                .onTapGesture {
                    isFocused = true
                }
                
                Button {
                    if (store.search) {
                        isFocused = false
                        store.clearSearch()
                    } else {
                        bottomSheetManager.present {
                           ChatsNewMessageView()
                                .bindBottomSheetScrollOffset(to: bottomSheetManager)
                        }
                    }
                } label: {
                    IconView(name: "plus_icon", size: 28, color: Theme.colors.text)
                        .rotationEffect(.degrees(store.search ? 45 : 0))
                }
                .buttonStyle(.plain)
                .frame(width: 48, height: 48)
                .glassEffect(.clear.interactive().tint(Theme.colors.glassBackdrop))
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, isKeyboardVisible ? Theme.spacing.lg : Theme.spacing.xxxl)
            .padding(.top, Theme.spacing.md)
            .padding(.bottom, isKeyboardVisible ? Theme.spacing.lg : Theme.spacing.xxxl)
            .animation(.normalSpring, value: store.search)
            .bottomGradientBackground(color: Theme.colors.background, height: isKeyboardVisible ? 0 : footerHeight)
        }
    }
}
