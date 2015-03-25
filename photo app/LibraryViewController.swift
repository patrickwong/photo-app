//
//  LibraryViewController.swift
//  photo app
//
//  Copyright (c) 2015 Patrick Wong. All rights reserved.
//

import UIKit
import Photos

let reuseIdentifier = "photocellID"

class LibraryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, PHPhotoLibraryChangeObserver, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {

    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var onBoardingTextBlock: UIView!
    
    var isPresenting: Bool = true // detects if this is the current view
    
    var images: PHFetchResult! = nil
    var imageManager = PHCachingImageManager()
    var selectedImage: Int!
    var cellSelectionFrame: CGRect!
    
    var imageCacheController: ImageCacheController!
    let cachingImageManager = PHCachingImageManager()
    
    var animationLength: NSTimeInterval = 0.5 // timing for transition animations


    override func viewDidLoad() {
        super.viewDidLoad()
        images = PHAsset.fetchAssetsWithMediaType(.Image, options: nil)
        imageCacheController = ImageCacheController(imageManager: imageManager, images: images, preheatSize: 1)
        PHPhotoLibrary.sharedPhotoLibrary().registerChangeObserver(self) // Registering for update notifications
        
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        
        self.photoCollectionView.reloadData()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(animated: Bool) {
        onBoardingTextBlock.alpha = 0.0
        if (images.count == 0){
            println("no images loaded")
            self.photoCollectionView.hidden = true
            delay(1.5, closure: { () -> () in
                UIView.animateWithDuration(self.animationLength, animations: { () -> Void in
                    self.onBoardingTextBlock.alpha = 1.0
                })
            })
        } else {
            print("images loaded successfully")
            self.photoCollectionView.hidden = false
        }
        self.photoCollectionView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count: Int = 0
        if(self.images != nil){
            count = self.images.count
        }
        
        return count
    }
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as PhotoCollectionViewCell
        cell.imageManager = imageManager
        cell.imageAsset = images?.objectAtIndex(indexPath.item) as? PHAsset // configure cell
        return cell
    }
    // PHPhotoLibraryChangeObserver
    func photoLibraryDidChange(changeInstance: PHChange!) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.images = PHAsset.fetchAssetsWithMediaType(.Image, options: nil)
            if (self.images.count == 0){
                println("no images loaded")
                self.photoCollectionView.hidden = true
            } else {
                print("images loaded successfully")
                self.photoCollectionView.hidden = false
            }
            self.photoCollectionView.reloadData()
        })
    }
    // tap on photo to segue photo detail view
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        println("segue to image \(indexPath.item)")
        selectedImage = indexPath.item
        var cellSelection = collectionView.cellForItemAtIndexPath(indexPath)
        cellSelectionFrame = cellSelection?.frame
        
        performSegueWithIdentifier("collectionSegue", sender: self)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "collectionSegue"){
            let controller: EditPhotoViewController = segue.destinationViewController as EditPhotoViewController
            controller.index = selectedImage
            controller.images = self.images
            controller.imageManager = self.imageManager
            
            controller.modalPresentationStyle = UIModalPresentationStyle.Custom
            controller.transitioningDelegate = self
        }
    }
    
    // custom transitions
    func animationControllerForPresentedController(presented: UIViewController!, presentingController presenting: UIViewController!, sourceController source: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
        isPresenting = true
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
        isPresenting = false
        return self
    }
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return animationLength
    }
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        println("animating transition")
        var containerView = transitionContext.containerView()
        var toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        var fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        var movingImage = UIImageView(frame: cellSelectionFrame)
        
        var phAsset = images[selectedImage] as PHAsset // make a copy of the image
        imageManager.requestImageForAsset(phAsset, targetSize: CGSize(width: 320, height: 320), contentMode: .AspectFill, options: nil) { image, info in
            movingImage.image = image
        }
        photoCollectionView.addSubview(movingImage)
        
//        var window = UIApplication.sharedApplication().keyWindow! // add image to master view
//        window.addSubview(movingImage)
    
        
        if (isPresenting) {
            containerView.addSubview(toViewController.view)
            toViewController.view.alpha = 0
            toViewController.view.alpha = 0.0
            var editPhotoViewController = toViewController as EditPhotoViewController
            var libraryEditViewController = fromViewController as LibraryViewController
            var finalImageView = editPhotoViewController.canvasImage
            
            editPhotoViewController.canvasImage.hidden = true

            UIView.animateWithDuration(animationLength, animations: { () -> Void in
                toViewController.view.alpha = 1
                 toViewController.view.alpha = 1
                 fromViewController.view.alpha = 0
                 movingImage.frame = finalImageView.frame
                 movingImage.contentMode = finalImageView.contentMode // making sure they have the same aspect ratio
                 movingImage.clipsToBounds = finalImageView.clipsToBounds
                }) { (finished: Bool) -> Void in
                    transitionContext.completeTransition(true)
                    editPhotoViewController.canvasImage.hidden = false
                    movingImage.removeFromSuperview()
            }
        } else {
//            containerView.addSubview(toViewController.view)
            fromViewController.view.alpha = 0.0
        
            var libraryEditViewController = toViewController as LibraryViewController
            var editPhotoViewController = fromViewController as EditPhotoViewController
            var finalImageView = libraryEditViewController.cellSelectionFrame
            
            var startingImageView = editPhotoViewController.canvasImage.frame
            movingImage.frame = startingImageView
            
            UIView.animateWithDuration(animationLength, animations: { () -> Void in
                fromViewController.view.alpha = 0
                movingImage.frame = self.cellSelectionFrame

                fromViewController.view.alpha = 0.0
                toViewController.view.alpha = 1
                }) { (finished: Bool) -> Void in
                    transitionContext.completeTransition(true)
                    fromViewController.view.removeFromSuperview()
                    libraryEditViewController.view.hidden = false
                    editPhotoViewController.view.hidden = true
//                    fromViewController.view.removeFromSuperview()
                    movingImage.removeFromSuperview()
            }
        }
    }
    // call a method after a delay
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
}