//
//  NewMessageView.swift
//  Bloom
//
//  Created by Аскольд on 28.06.2026.
//

import SwiftUI
import BlurSwiftUI

struct NewMessageView: View {
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(1...15, id: \.self) { index in
                    ChatsSearchRowView(userId: index, sheet: true)
                }
            }
        }
        .safeAreaInset(edge: .top, spacing: 0) {
            NewMessageHeaderView()
        }
    }
}
