//
//  ChatMediaSheetView.swift
//  Bloom
//
//  Created by Аскольд on 08.07.2026.
//

import SwiftUI

struct ChatMediaSheetView: View {
    var body: some View {
        ScrollView {
            // TODO: Implement LazyVGrid for displaying user's gallery idk
        }
        .safeAreaInset(edge: .top, spacing: 0) {
            ChatMediaSheetHeaderView()
        }
    }
}
