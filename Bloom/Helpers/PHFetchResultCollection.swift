//
//  PHFetchResultCollection.swift
//  Bloom
//
//  Created by Аскольд on 08.07.2026.
//

import Photos

struct PHFetchResultCollection: RandomAccessCollection {
    typealias Element = PHAsset
    typealias Index = Int
    
    let fetchResult: PHFetchResult<PHAsset>
    
    var startIndex: Int { 0 }
    var endIndex: Int { fetchResult.count }
    
    var isEmpty: Bool { fetchResult.count == 0 }
    
    subscript(position: Int) -> PHAsset {
        fetchResult.object(at: position)
    }
}
