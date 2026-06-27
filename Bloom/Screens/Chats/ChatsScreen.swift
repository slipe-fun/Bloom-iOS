//
//  ChatsScreen.swift
//  Bloom
//
//  Created by Аскольд on 19.06.2026.
//

import SwiftUI

struct ChatsScreen: View {
    @State private var scrollY: CGFloat = 0
    @State private var keyboardHeight: CGFloat = 0
    @State private var footerHeight: CGFloat = 0
    @State private var store = SearchStore()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(1...5, id: \.self) { index in
                        ChatsRowView(userId: index)
                    }
                }
                .padding(.bottom, footerHeight)
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
            .offset(y: store.search ? -60 : 0)
            .opacity(store.search ? 0 : 1)
            
            if (store.search) {
                ChatsSearchView(footerHeight: footerHeight)
            }
            
            KeyboardPinnedView(keyboardHeight: $keyboardHeight, footerHeight: $footerHeight) {
                ChatsFooterView(keyboardHeight: keyboardHeight, footerHeight: footerHeight)
            }
        }
        .environment(store)
    }
}
