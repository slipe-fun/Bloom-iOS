//
//  ChatsScreen.swift
//  Bloom
//
//  Created by Аскольд on 19.06.2026.
//

import SwiftUI
import BlurSwiftUI

struct ChatsScreen: View {
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: Theme.spacing.md) {
                    ForEach(1...50, id: \.self) { index in
                        HStack {
                            Text("Hi")
                                .font(Theme.font.medium(size: Theme.fontSize.xxl))
                                
                                .foregroundStyle(Theme.colors.text)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 100)
                        .padding()
                        .background(Theme.colors.foreground, in: .rect(cornerRadius: Theme.radius.xl))
                    }
                }
                .padding()
            }
            .frame(maxWidth: .infinity)
            .scrollIndicators(.hidden)
            
            VStack {
                VariableBlur(direction: .down)
                    .dimmingTintColor(Theme.colors.background)
                    .dimmingOvershoot(.relative(fraction: 1))
                    .passesTouchesThrough(true)
                    .frame(height: 100)
                    .ignoresSafeArea()
                
                Spacer()
            }
        }
    }
}
