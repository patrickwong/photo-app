//
//  ImageCacheController.swift
//  photo app
//
//  Created by Brian Bailey on 3/17/15.
//  Copyright (c) 2015 Patrick Wong. All rights reserved.
//

import Foundation
import Photos
import UIKit

class ImageCacheController: PHCachingImageManager {
    
    private var cachedIndices = NSIndexSet()
    var cachePreheatSize: Int
    var imageCache: PHCachingImageManager
    var images: PHFetchResult
    var targetSize = CGSize(width: 320, height: 320)
    var contentMode = PHImageContentMode.AspectFill
    
    init(imageManager: PHCachingImageManager, images: PHFetchResult, preheatSize: Int = 1) {
        self.cachePreheatSize = preheatSize
        self.imageCache = imageManager
        self.images = images
    }
    
    func updateVisibleCells(visibleCells: [NSIndexPath]) {
        let updatedCache = NSMutableIndexSet()
        for path in visibleCells {
            updatedCache.addIndex(path.item)
        }
        let minCache = max(0, updatedCache.firstIndex - cachePreheatSize)
        let maxCache = min(images.count - 1, updatedCache.lastIndex + cachePreheatSize)
        updatedCache.addIndexesInRange(NSMakeRange(minCache, maxCache - minCache + 1))
        
        // Which indices can be chucked?
        self.cachedIndices.enumerateIndexesUsingBlock {
            index, _ in
            if !updatedCache.containsIndex(index) {
                let asset: AnyObject! = self.images[index]
                self.imageCache.stopCachingImagesForAssets([asset], targetSize: self.targetSize, contentMode: self.contentMode, options: nil)
                println("Stopping caching image \(index)")
                
            }
        }
        
        // And which are new?
        updatedCache.enumerateIndexesUsingBlock {
            index, _ in
            if !self.cachedIndices.containsIndex(index) {
                let asset: AnyObject! = self.images[index]
                self.imageCache.startCachingImagesForAssets([asset], targetSize: self.targetSize, contentMode: self.contentMode, options: nil)
                println("Starting caching image \(index)")
            }
        }
        cachedIndices = NSIndexSet(indexSet: updatedCache)
    }
}
