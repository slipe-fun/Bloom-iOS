//
//  ChatMediaSheetPhotoView.swift
//  Bloom
//
//  Created by Аскольд on 08.07.2026.
//

import SwiftUI
import Photos

struct ChatMediaSheetPhotoView: View {
    @Environment(\.displayScale) private var displayScale
    @State private var image: UIImage?
    @State private var requestID: PHImageRequestID?
    @ObservedObject var manager: PhotoLibraryManager
    
    let asset: PHAsset
    let cellSize: CGFloat
    
    private static let cache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 150
        return cache
    }()
    
    private var isSelected: Bool {
        return manager.selectedAssets.contains(asset)
    }
    
    private var isDisabled: Bool {
        let isLimitReached = manager.selectedAssets.count >= PhotoLibraryManager.maxSelectionLimit
        
        return isLimitReached && !isSelected
    }
        
    var body: some View {
        ZStack(alignment: .topTrailing) {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: cellSize, height: cellSize)
                    .clipped()
                    .transaction { transaction in
                        transaction.animation = nil
                    }
            }
                
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Theme.colors.primary)
                    .scaleEffect(isSelected ? 1 : 0.85)
                    .opacity(isSelected ? 1 : 0)
                if isSelected {
                    Text("\((manager.selectedAssets.firstIndex(of: asset) ?? 0) + 1)")
                        .font(Theme.font.footnote)
                        .foregroundStyle(Theme.colors.white)
                }
            }
            .frame(width: 24, height: 24)
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .strokeBorder(Theme.colors.white, lineWidth: 1.75)
                    .shadow(radius: isSelected ? 0 : 2)
            }
            .offset(x: -Theme.spacing.xs, y: Theme.spacing.xs)
        }
        .frame(width: cellSize, height: cellSize)
        .contentShape(Rectangle())
        .clipShape(
            RoundedRectangle(cornerRadius: Theme.radius.sm)
        )
        .opacity(isDisabled ? 0.4 : 1.0)
        .animation(.quickSpring, value: isDisabled)
        .allowsHitTesting(!isDisabled)
        .sensoryFeedback(.selection, trigger: isSelected)
        .onAppear {
            loadImage(size: cellSize)
        }
        .onDisappear {
            cancelRequest()
        }
    }

    private func cancelRequest() {
        if let requestID = requestID {
            PhotoLibraryManager.imageManager.cancelImageRequest(requestID)
            self.requestID = nil
        }
    }

    private func loadImage(size: CGFloat) {
        guard size > 0 else { return }
        cancelRequest()

        let key = asset.localIdentifier as NSString

        if let cached = Self.cache.object(forKey: key) {
            self.image = cached
            return
        }

        let options = PHImageRequestOptions()
        options.isNetworkAccessAllowed = true
        options.deliveryMode = .opportunistic
        options.resizeMode = .fast

        let targetSize = CGSize(width: size * displayScale, height: size * displayScale)

        requestID = PhotoLibraryManager.imageManager.requestImage(
            for: asset,
            targetSize: targetSize,
            contentMode: .aspectFill,
            options: options
        ) { result, info in
            let isCancelled = info?[PHImageCancelledKey] as? Bool ?? false
            let isDegraded = info?[PHImageResultIsDegradedKey] as? Bool ?? false
            
            if !isCancelled, let result = result {
                if !isDegraded {
                    Self.cache.setObject(result, forKey: key)
                }
                
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
