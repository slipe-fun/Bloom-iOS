//
//  SettingsScreen.swift
//  Bloom
//
//  Created by Аскольд on 20.06.2026.
//

import SwiftUI
import BlurSwiftUI

struct SettingsScreen: View {
    @State private var scrollY: CGFloat = 0
    
    @Environment(AppRouter.self) private var router
    
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
        .disabled(true)
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
