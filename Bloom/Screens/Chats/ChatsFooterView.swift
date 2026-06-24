//
//  ChatsFooterView.swift
//  Bloom
//
//  Created by Аскольд on 22.06.2026.
//

import SwiftUI

struct ChatsFooterView: View {
    @State private var text: String = ""
    @State private var keyboard: KeyboardObserver = KeyboardObserver(offset: 12)
    @FocusState private var isFocused: Bool
    
    var body: some View {
        GlassEffectContainer {
                HStack(spacing: Theme.spacing.md) {
                    HStack(spacing: 0) {
                        VStack(alignment: .center) {
                            IconView(name: "magnifyingglass_icon", size: 24, color: Theme.colors.secondaryText)
                        }
                        .frame(width: 48, height: 48)
                        
                        TextField(
                            "",
                            text: $text,
                            prompt:
                                Text("Search chats")
                                    .font(Theme.font.medium(size: Theme.fontSize.md))
                                    .foregroundStyle(Theme.colors.secondaryText)
                        )
                        .frame(maxHeight: .infinity)
                        .focused($isFocused)
                        .textFieldStyle(.plain)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .glassEffect(.clear.interactive().tint(Theme.colors.pressable.opacity(0.55)))
                    
                    Button {
                        print("Swag")
                    } label: {
                        IconView(name: "plus_icon", size: 30, color: Theme.colors.text)
                    }
                    .frame(width: 48)
                    .frame(height: 48)
                    .glassEffect(.clear.interactive().tint(Theme.colors.glassBackdrop))
                }
                .offset(y: -keyboard.height)
                .animation(keyboard.animation, value: keyboard.height)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, keyboard.progress >= 0.1 || keyboard.progress <= 0.1 ? Theme.spacing.xxxl : Theme.spacing.xxxl)
                .padding(.top, Theme.spacing.md)
                .padding(.bottom, Theme.spacing.xxxl)
                .ignoresSafeArea(edges: .bottom)
                .background(
                    ZStack {
                        LinearGradient(
                            colors: [
                                Theme.colors.background.opacity(0.8),
                                Theme.colors.background.opacity(0.45),
                                Theme.colors.background.opacity(0.0)
                            ],
                            startPoint: .bottom,
                            endPoint: .top
                        )
                        .ignoresSafeArea(edges: .bottom)
                    }
                )
        }
    }
}
