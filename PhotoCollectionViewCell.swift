//
//  PhotoCollectionViewCell.swift
//  photo app
//
//  Created by Patrick Wong on 3/14/15.
//  Copyright (c) 2015 Patrick Wong. All rights reserved.
//

import UIKit
import Photos

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoCellImage: UIImageView!
    
    var imageAsset: PHAsset? { // get the image
        didSet {
            self.imageManager?.requestImageForAsset(imageAsset!, targetSize: CGSize(width: 320, height: 320), contentMode: .AspectFill, options: nil) { image, info in
                self.photoCellImage.image = image
            }
        }
    }
    
    var imageManager: PHImageManager?
    
}
