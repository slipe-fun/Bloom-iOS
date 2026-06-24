//
//  ChatsScreen.swift
//  Bloom
//
//  Created by Аскольд on 19.06.2026.
//

import SwiftUI
import BlurSwiftUI

struct ChatsScreen: View {
    @State private var scrollY: CGFloat = 0
    @State private var keyboardHeight: CGFloat = 0
    @State private var footerHeight: CGFloat = 0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(1...30, id: \.self) { index in
                        ChatRowView(userId: String(index))
                    }
                }
                .padding(.bottom, footerHeight + keyboardHeight)
            }
            .scrollIndicators(.hidden)
            .frame(maxWidth: .infinity)
            .onScrollGeometryChange(for: CGFloat.self) { geometry in
                geometry.contentOffset.y + geometry.contentInsets.top
            } action: { oldValue, newValue in
                self.scrollY = newValue
            }
            .safeAreaInset(edge: .top, spacing: 0) {
                ChatsHeaderView(title: "Bloom", scrollY: scrollY)
            }
            .simultaneousGesture(
                DragGesture().onChanged { value in
                    if abs(value.translation.height) > 10 {
                        UIApplication.shared.sendAction(
                            #selector(UIResponder.resignFirstResponder),
                            to: nil,
                            from: nil,
                            for: nil
                        )
                    }
                }
            )
            
            KeyboardPinnedView(keyboardHeight: $keyboardHeight, footerHeight: $footerHeight) {
                ChatsFooterView(keyboardHeight: keyboardHeight, footerHeight: footerHeight)
            }
        }
    }
}
