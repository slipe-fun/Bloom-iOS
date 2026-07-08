//
//  ChatMediaSheetPhotoLibraryManager.swift
//  Bloom
//
//  Created by Аскольд on 08.07.2026.
//

import SwiftUI
import Photos

class PhotoLibraryManager: ObservableObject {
    @Published var assets: [PHAsset] = []
    @Published var selectedAssets: Set<PHAsset> = []
    
    @Published var permissionStatus: PHAuthorizationStatus = .notDetermined
    
    static let imageManager = PHCachingImageManager()
    
    func checkPermissionAndFetch() {
        let currentStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        
        Task { @MainActor in
            self.permissionStatus = currentStatus
        }
        
        switch currentStatus {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { newStatus in
                Task { @MainActor in
                    self.permissionStatus = newStatus
                    if newStatus == .authorized || newStatus == .limited {
                        self.fetchAssets()
                    }
                }
            }
        case .authorized, .limited:
            fetchAssets()
        case .denied, .restricted:
            break
        @unknown default:
            break
        }
    }
    
    private func fetchAssets() {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let fetchResult = PHAsset.fetchAssets(with: .image, options: options)
        var newAssets = [PHAsset]()
        
        fetchResult.enumerateObjects { asset, _, _ in
            newAssets.append(asset)
        }
        
        Task { @MainActor in
            self.assets = newAssets
        }
    }
    
    func toggleSelection(for asset: PHAsset) {
        if selectedAssets.contains(asset) {
            selectedAssets.remove(asset)
        } else {
            selectedAssets.insert(asset)
        }
    }
}
