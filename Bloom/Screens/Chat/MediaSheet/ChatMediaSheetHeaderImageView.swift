//
//  ChatMediaSheetHeaderImageView.swift
//  Bloom
//
//  Created by Аскольд on 08.07.2026.
//

import SwiftUI
import Photos

struct ChatMediaSheetHeaderImageView: View {
    @Environment(\.displayScale) private var displayScale
    @State private var image: UIImage?
    
    let asset: PHAsset

    var body: some View {
        ZStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            }
        }
        .frame(width: 31, height: 36)
        .clipped()
        .clipShape(
            RoundedRectangle(cornerRadius: Theme.radius.xxs + 2)
        )
        .onAppear {
            loadImage()
        }
    }

    private func loadImage() {
        let options = PHImageRequestOptions()
        options.isNetworkAccessAllowed = true
        options.deliveryMode = .opportunistic
        options.resizeMode = .fast

        let targetSize = CGSize(width: 30 * displayScale, height: 35 * displayScale)

        PhotoLibraryManager.imageManager.requestImage(
            for: asset,
            targetSize: targetSize,
            contentMode: .aspectFill,
            options: options
        ) { result, info in
            
            if let result = result {
                if Thread.isMainThread {
                    self.image = result
                } else {
                    Task { @MainActor in
                        self.image = result
                    }
                }
            }
        }
    }
}
