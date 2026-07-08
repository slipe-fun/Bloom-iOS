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
    
    let asset: PHAsset
    let manager: PhotoLibraryManager
    let cellSize: CGFloat
        
    var body: some View {
            ZStack(alignment: .topTrailing) {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: cellSize, height: cellSize)
                        .transaction { transaction in
                            transaction.animation = nil
                        }
                }
                    
                if manager.selectedAssets.contains(asset) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title3)
                        .foregroundColor(.blue)
                        .background(Circle().fill(Color.white))
                        .padding(4)
                } else {
                    Image(systemName: "circle")
                        .font(.title3)
                        .foregroundColor(.white.opacity(0.8))
                        .shadow(radius: 1)
                        .padding(4)
                }
            }
            .frame(width: cellSize, height: cellSize)
            .clipShape(
                RoundedRectangle(cornerRadius: Theme.radius.sm)
            )
            .onAppear {
                loadImage(size: cellSize)
            }
            .onDisappear {
                if let requestID = requestID {
                    PHImageManager.default().cancelImageRequest(requestID)
                }
            }
    }
        
    private func loadImage(size: CGFloat) {
        let options = PHImageRequestOptions()
        options.isNetworkAccessAllowed = true
        options.deliveryMode = .opportunistic
        options.resizeMode = .fast
            
        let targetSize = CGSize(width: cellSize * displayScale, height: displayScale)
            
        requestID = PhotoLibraryManager.imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options) { result, info in
            
            let isCancelled = info?[PHImageCancelledKey] as? Bool ?? false
                
            if !isCancelled, let result = result {
                self.image = result
            }
        }
    }
}
