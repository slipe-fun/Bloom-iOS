//
//  ChatListView.swift
//  Bloom
//
//  Created by Аскольд on 10.08.2026.
//

import SwiftUI
import BlurSwiftUI
import BlurUIKit

struct ChatListView: View {
    @Environment(Router.self) private var router
    @State private var searchText = ""
    @State private var scrollY: CGFloat = 0

    var body: some View {
        List {
            ForEach(1...20, id: \.self) { id in
                ChatsListRowView(userId: id)
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .onScrollGeometryChange(for: CGFloat.self) { geometry in
            geometry.contentOffset.y + geometry.contentInsets.top
        } action: { oldValue, newValue in
            self.scrollY = newValue
        }
        .scrollDismissesKeyboard(.immediately)
        .scrollEdgeEffectHidden(true, for: .all)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .searchable(text: $searchText)
        .toolbarBackground(.hidden, for: .bottomBar)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbar {
            ChatListToolbar(scrollY: scrollY)
        }
        .topVariableBlur()
        .bottomSafeAreaGradient()
    }
}
