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
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(1...30, id: \.self) { index in
                    ChatRowView(userId: String(index))
                }
            }
            .padding(.bottom, 80)
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
    }
}
