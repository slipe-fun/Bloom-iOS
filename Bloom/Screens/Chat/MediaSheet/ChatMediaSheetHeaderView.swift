//
//  ChatMediaSheetHeaderView.swift
//  Bloom
//
//  Created by Аскольд on 08.07.2026.
//

import SwiftUI
import Photos

struct ChatMediaSheetHeaderView: View {
    @Environment(BottomSheetManager.self) private var bottomSheetManager
    @ObservedObject var manager: PhotoLibraryManager
    @State private var isAssetsEmpty: Bool = true
    
    private var selectedAssets: [PHAsset] {
        Array(manager.selectedAssets).reversed()
    }
    
    var body: some View {
            HStack(spacing: 0) {
                Button {
                    bottomSheetManager.dismiss()
                } label: {
                    IconView(name: "x_icon", size: 26, color: Theme.colors.text)
                }
                .buttonStyle(.plain)
                .frame(width: 44, height: 44)
                .glassEffect(.clear.interactive().tint(Theme.colors.glassBackdrop))
                
                Text("Gallery")
                    .font(Theme.font.title4)
                    .foregroundStyle(Theme.colors.text)
                    .frame(maxWidth: .infinity)
                
                Button {
                   print(1)
                } label: {
                    ZStack {
                        ForEach(Array(selectedAssets.enumerated()), id: \.element.localIdentifier) { index, item in
                            ChatMediaSheetHeaderImageView(asset: item)
                                .offset(x: -(CGFloat(index) * 8), y: CGFloat(index) * 3)
                                .opacity(max(0, 1 - Double(index) * 0.6))
                                .rotationEffect(.degrees(-(Double(index) * 6)))
                                .zIndex(-Double(index))
                        }
                    }
                    .offset(y: 2)
                    .frame(width: 44, height: 44, alignment: .bottom)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.radius.full))
                }
                .buttonStyle(.plain)
                .frame(width: 44, height: 44)
                .glassEffect(.clear.interactive().tint(Theme.colors.glassBackdrop))
                .blur(radius: selectedAssets.isEmpty ? 8 : 0)
                .opacity(selectedAssets.isEmpty ? 0 : 1)
            }
            .padding(.top, Theme.spacing.lg)
            .padding(.horizontal, Theme.spacing.lg)
            .padding(.bottom, Theme.spacing.md)
            .topGradientBackground(color: .clear)
            .onChange(of: selectedAssets) { oldValue, newValue in
                withAnimation(.slowSpring) {
                    self.isAssetsEmpty = newValue.isEmpty
                }
            }
    }
}
