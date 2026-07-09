//
//  ChatMediaSheetView.swift
//  Bloom
//
//  Created by Аскольд on 08.07.2026.
//

import SwiftUI

struct ChatMediaSheetView: View {
    @ObservedObject var manager: PhotoLibraryManager
    @Environment(\.displayScale) private var displayScale
    
    let columns = [
        GridItem(.flexible(), spacing: Theme.spacing.sm - 2),
        GridItem(.flexible(), spacing: Theme.spacing.sm - 2),
        GridItem(.flexible(), spacing: Theme.spacing.sm - 2)
    ]
    
    var body: some View {
        GeometryReader { geometry in
            let spacing = Theme.spacing.sm - 2
            let totalSpacing = spacing * 4
            let availableWidth = max(0, geometry.size.width - totalSpacing)
            let size = availableWidth / 3
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: spacing) {
                    ForEach(manager.assets, id: \.localIdentifier) { asset in
                        Button {
                            withAnimation(.springy) {
                                manager.toggleSelection(for: asset)
                            }
                        } label: {
                            ChatMediaSheetPhotoView(manager: manager, asset: asset, cellSize: size)
                        }
                        .buttonStyle(PhotoPressButtonStyle())
                    }
                }
                .padding(.horizontal, spacing)
            }
            .safeAreaInset(edge: .top, spacing: 0) {
                ChatMediaSheetHeaderView(manager: manager)
            }
            .safeAreaInset(edge: .bottom, spacing: 0) {
                ChatMediaSheetFooterView()
            }
        }
    }
}
