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
            VStack(spacing: Theme.spacing.md) {
                ForEach(1...30, id: \.self) { index in
                    HStack {
                        Text("Hi")
                            .font(Theme.font.medium(size: Theme.fontSize.xxl))
                            .foregroundStyle(Theme.colors.text)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 100)
                    .padding(.horizontal, Theme.spacing.lg)
                    .background(Theme.colors.foreground, in: .rect(cornerRadius: Theme.radius.xl))
                }
            }
            .padding(.bottom, 80)
            .padding(.horizontal, Theme.spacing.lg)
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
