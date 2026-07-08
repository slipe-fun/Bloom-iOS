//
//  ChatMediaSheetPhotoLibraryManager.swift
//  Bloom
//
//  Created by Аскольд on 08.07.2026.
//

import SwiftUI
import Photos

@MainActor
class PhotoLibraryManager: NSObject, ObservableObject, PHPhotoLibraryChangeObserver {
    @Published var fetchResult: PHFetchResult<PHAsset> = PHFetchResult<PHAsset>()
    @Published var selectedAssets: [PHAsset] = []
    @Published var permissionStatus: PHAuthorizationStatus = .notDetermined
    
    static let imageManager = PHCachingImageManager()
    static let maxSelectionLimit = 5
    private var hasFetched = false
    
    var assets: PHFetchResultCollection {
        PHFetchResultCollection(fetchResult: fetchResult)
    }
    
    override init() {
        super.init()
        PHPhotoLibrary.shared().register(self)
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    func checkPermissionAndFetch() {
        guard !hasFetched else { return }
        
        let currentStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        self.permissionStatus = currentStatus
        
        switch currentStatus {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] newStatus in
                Task { @MainActor in
                    self?.permissionStatus = newStatus
                    if newStatus == .authorized || newStatus == .limited {
                        self?.fetchAssets()
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
        
        self.fetchResult = PHAsset.fetchAssets(with: .image, options: options)
        self.hasFetched = true
    }
    
    func toggleSelection(for asset: PHAsset) {
        if let index = selectedAssets.firstIndex(of: asset) {
            selectedAssets.remove(at: index)
        } else {
            guard selectedAssets.count < Self.maxSelectionLimit else { return }
            selectedAssets.append(asset)
        }
    }
    
    nonisolated func photoLibraryDidChange(_ changeInstance: PHChange) {
        Task { @MainActor in
            guard let changeDetails = changeInstance.changeDetails(for: self.fetchResult) else { return }
            self.fetchResult = changeDetails.fetchResultAfterChanges
        }
    }
}
