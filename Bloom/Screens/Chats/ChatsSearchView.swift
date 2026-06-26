//
//  ChatsSearchView.swift
//  Bloom
//
//  Created by Аскольд on 27.06.2026.
//

import SwiftUI

struct ChatsSearchView: View {
    @Environment(\.customSafeArea) private var safeArea
    @State private var scrollY: CGFloat = 0
    @State private var collapsed: Bool = false
    
    let footerHeight: CGFloat
    
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(1...5, id: \.self) { index in
                        
                    }
                }
                .padding(.bottom, footerHeight)
            }
            .scrollIndicators(.hidden)
            .frame(maxWidth: .infinity)
            .onScrollGeometryChange(for: CGFloat.self) { geometry in
                geometry.contentOffset.y + geometry.contentInsets.top
            } action: { oldValue, newValue in
                withAnimation(.normalSpring) {
                    self.collapsed = newValue > Theme.spacing.xxxl + safeArea.top
                }
                self.scrollY = newValue
            }
            .safeAreaInset(edge: .top, spacing: 0) {
                ChatsSearchHeaderView(scrollY: scrollY, collapsed: collapsed)
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
            
                if (collapsed) {
                    ChatsSearchFloatHeaderView()
                        .transition(
                            AnyTransition.opacity
                                .combined(with: .blur(radius: 4))
                        )
                }
        }
        .background(Theme.colors.background)
        .transition(.opacity.combined(with: .offset(y: 60)))
    }
}
