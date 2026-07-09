//
//  ChatMediaSheetView.swift
//  Bloom
//
//  Created by Аскольд on 08.07.2026.
//

import SwiftUI

struct ChatMediaSheetView: View {
    @StateObject private var photoManager = PhotoLibraryManager()
    @Environment(\.displayScale) private var displayScale
    @Environment(\.openURL) private var openURL
    
    let columns = [
        GridItem(.flexible(), spacing: Theme.spacing.sm - 2),
        GridItem(.flexible(), spacing: Theme.spacing.sm - 2),
        GridItem(.flexible(), spacing: Theme.spacing.sm - 2)
    ]
    
    
    var body: some View {
       renderViewForStatus()
            .onAppear {
                photoManager.checkPermissionAndFetch()
            }
    }
    
    private func galleryGrid(limited: Bool) -> some View {
        GeometryReader { geometry in
            let spacing = Theme.spacing.sm - 2
            let totalSpacing = spacing * 4
            let availableWidth = max(0, geometry.size.width - totalSpacing)
            let size = availableWidth / 3
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: spacing) {
                    ForEach(photoManager.assets, id: \.localIdentifier) { asset in
                        Button {
                            withAnimation(.springy) {
                                photoManager.toggleSelection(for: asset)
                            }
                        } label: {
                            ChatMediaSheetPhotoView(manager: photoManager, asset: asset, cellSize: size)
                        }
                        .buttonStyle(PhotoPressButtonStyle())
                    }
                }
                .padding(.horizontal, spacing)
                
                Button {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        openURL(url)
                    }
                } label: {
                    Text("Allow full access")
                        .font(Theme.font.button)
                        .foregroundStyle(Theme.colors.white)
                }
                .padding(.horizontal, Theme.spacing.xxxl + 24)
                .buttonStyle(.plain)
                .frame(height: 52)
                .glassEffect(.regular.interactive().tint(Theme.colors.primary))
            }
            .onDisappear {
                photoManager.selectedAssets = []
            }
            .safeAreaInset(edge: .top, spacing: 0) {
                ChatMediaSheetHeaderView(manager: photoManager)
            }
            .safeAreaInset(edge: .bottom, spacing: 0) {
                ChatMediaSheetFooterView()
            }
        }
    }
    
    @ViewBuilder
    private func renderViewForStatus() -> some View {
        switch photoManager.permissionStatus {
        case .notDetermined:
            ChatMediaSheetEmptyView(manager: photoManager)
            
        case .restricted:
            ChatMediaSheetEmptyView(manager: photoManager)
            
        case .denied:
            ChatMediaSheetEmptyView(manager: photoManager)
            
        case .authorized:
            galleryGrid(limited: false)
            
        case .limited:
            galleryGrid(limited: true)
            
        @unknown default:
            ChatMediaSheetEmptyView(manager: photoManager)
        }
    }
}
