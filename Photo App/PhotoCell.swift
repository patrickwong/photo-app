//
//  PhotoCell.swift
//  Photo App
//
//  Created by Brian Bailey on 3/10/15.
//  Copyright (c) 2015 Patrick Wong. All rights reserved.
//

import UIKit
import Photos

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var imageThumbnail: UIImageView!
    

    func setThumbnailImage(thumbnailImage: UIImage){
        self.imageThumbnail.image = thumbnailImage
    }
}
