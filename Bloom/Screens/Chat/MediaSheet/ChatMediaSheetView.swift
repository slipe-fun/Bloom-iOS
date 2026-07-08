//
//  ChatMediaSheetView.swift
//  Bloom
//
//  Created by Аскольд on 08.07.2026.
//

import SwiftUI

struct ChatMediaSheetView: View {
    @StateObject private var manager = PhotoLibraryManager()
    @Environment(\.displayScale) private var displayScale
    
    let columns = [
        GridItem(.flexible(), spacing: Theme.spacing.sm - 2),
        GridItem(.flexible(), spacing: Theme.spacing.sm - 2),
        GridItem(.flexible(), spacing: Theme.spacing.sm - 2)
    ]
    
    var body: some View {
        GeometryReader { geometry in
            
            let size = (geometry.size.width - ((Theme.spacing.sm - 2) * 4)) / 3
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: Theme.spacing.sm - 2) {
                    ForEach(manager.assets, id: \.localIdentifier) { asset in
                        ChatMediaSheetPhotoView(asset: asset, manager: manager, cellSize: size)
                            .onTapGesture {
                                withAnimation(.quickSpring) {
                                    manager.toggleSelection(for: asset)
                                }
                            }
                    }
                }
                .padding(.horizontal, Theme.spacing.sm - 2)
            }
            .safeAreaInset(edge: .top, spacing: 0) {
                ChatMediaSheetHeaderView()
            }
            .onAppear {
                manager.checkPermissionAndFetch()
            }
        }
    }
}
