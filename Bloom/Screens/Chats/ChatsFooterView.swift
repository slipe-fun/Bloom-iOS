//
//  ChatsFooterView.swift
//  Bloom
//
//  Created by Аскольд on 22.06.2026.
//

import SwiftUI

struct ChatsFooterView: View {
    @State private var text: String = ""
    @FocusState private var isFocused: Bool
    let keyboardHeight: CGFloat
    let footerHeight: CGFloat
    
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
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentShape(Rectangle())
                    .focused($isFocused)
                    .font(Theme.font.medium(size: Theme.fontSize.md))
                    .padding(.trailing, Theme.spacing.md)
                    .foregroundStyle(Theme.colors.text)
                    .textFieldStyle(.plain)
                    .tint(Theme.colors.primary)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .glassEffect(.clear.interactive().tint(Theme.colors.pressable.opacity(0.55)))
                .contentShape(Rectangle())
                .onTapGesture {
                    isFocused = true
                }
                
                Button {
                    print("Swag")
                } label: {
                    IconView(name: "plus_icon", size: 30, color: Theme.colors.text)
                        .rotationEffect(Angle(degrees: isFocused ? 45 : 0))
                }
                .buttonStyle(.plain)
                .frame(width: 48)
                .frame(height: 48)
                .glassEffect(.clear.interactive().tint(Theme.colors.glassBackdrop))
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, keyboardHeight > 0 ? Theme.spacing.lg : Theme.spacing.xxxl)
            .padding(.top, Theme.spacing.md)
            .padding(.bottom, keyboardHeight > 0 ? Theme.spacing.lg : Theme.spacing.xxxl)
            .animation(.quickSpring, value: isFocused)
            .background(alignment: .top) {
                ZStack {
                    LinearGradient(
                        colors: [
                            Theme.colors.background.opacity(0.8),
                            Theme.colors.background.opacity(0.45),
                            Theme.colors.background.opacity(0.0)
                        ],
                        startPoint: UnitPoint(x: 0.5, y: keyboardHeight > 0 ? (footerHeight / (keyboardHeight + footerHeight)) : 1.0),
                        endPoint: .top
                    )
                    .ignoresSafeArea(edges: .bottom)
                    .frame(minHeight: keyboardHeight + footerHeight)
                }
            }
        }
    }
}
