//
//  PhotoCollectionViewController.swift
//  Photo App
//
//  Created by Brian Bailey on 3/9/15.
//  Copyright (c) 2015 Patrick Wong. All rights reserved.
//

import UIKit
import Photos

let reuseIdentifier = "Cell"

class PhotoCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, PHPhotoLibraryChangeObserver  {

    @IBOutlet weak var collectionView: UICollectionView!

    let reuseIdentifier = "photoCell"
    let albumName = "Photo App" // displayed app album name
    
    var albumFound :  Bool = false
    var assetCollection : PHAssetCollection! // specific folder for our app
    var photosAsset : PHFetchResult! = nil // array of photos in asset collection
    let imageManager  = PHCachingImageManager.defaultManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let result = PHAssetCollection.fetchMomentsWithOptions(nil)
        let rec = result.firstObject as PHAssetCollection!
        if rec == nil {
            return
        }
        self.photosAsset = PHAsset.fetchAssetsInAssetCollection(rec, options: nil)
        PHPhotoLibrary.sharedPhotoLibrary().registerChangeObserver(self)

        // Do any additional setup after loading the view.
        
        // Check if an album for the app exists, if not, create it
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
        
        
        let collection = PHAssetCollection.fetchAssetCollectionsWithType(.Album, subtype: .Any , options: fetchOptions)
        if (collection.firstObject != nil ){
            // found the album
            self.albumFound = true
            self.assetCollection = collection.firstObject as PHAssetCollection
        } else {
            // create the folder
            NSLog("\nfolder \"%@\" does not exist\nCreating now...", albumName)
            PHPhotoLibrary.sharedPhotoLibrary().performChanges({ () -> Void in
                let request = PHAssetCollectionChangeRequest.creationRequestForAssetCollectionWithTitle(self.albumName)
                }, completionHandler: { (success:Bool, error:NSError!) -> Void in
                    NSLog("Creation of folder -> %@", (success ? "Success":"Error!"))
                    self.albumFound = (success ? true:false)
            })
        }
    }
    
    override func viewDidAppear(animated: Bool) {

        
        // fetch photos from the collection
        // self.photosAsset = PHAsset.fetchAssetsInAssetCollection(self.assetCollection, options: nil)

        
        // handle no photos in the asset collection
        // ...have a label that says "No Photos", thoughts guys? -b
        
        self.collectionView.reloadData()
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "photoDetailSegue"){
            let controller:PhotoDetailViewController = segue.destinationViewController as PhotoDetailViewController
            let indexPath: NSIndexPath = self.collectionView.indexPathForCell(sender as UICollectionViewCell)!
            controller.index = indexPath.item
            controller.photosAsset = self.photosAsset
            controller.assetCollection = self.assetCollection
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        photosAsset = nil
        // Dispose of any resources that can be recreated.
    }
    
    // UICollectionViewDataSource required methods
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count : Int = 0
        if (self.photosAsset != nil){
            count = self.photosAsset.count
        }
        return count; // number of photos in album we currently have
        // number of cells that we need to create are the number that are in the album we currently have
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: PhotoCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as PhotoCell // gets cell and creates it, displaying it on the view controller
        
        //configure cell
    
        let asset: PHAsset = self.photosAsset[indexPath.item] as PHAsset
        PHImageManager.defaultManager().requestImageForAsset(asset, targetSize: PHImageManagerMaximumSize, contentMode: .AspectFill, options: nil, resultHandler: {(result, info)in
            cell.setThumbnailImage(result)
        })
        
        return cell
    }
    
    // UICollectionViewDelegateFlowLayout method
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 4
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1
    }
    
    // PHPhotoLibraryChangeObserver method
    // This callback is invoked on an arbitrary serial queue. If you need this to be handled on a specific queue, you should redispatch appropriately
    func photoLibraryDidChange(changeInstance: PHChange!) {
        if let changeDetails = changeInstance.changeDetailsForFetchResult(photosAsset){
            self.collectionView.reloadData()
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
