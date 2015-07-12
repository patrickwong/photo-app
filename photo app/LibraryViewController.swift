//
//  LibraryViewController.swift
//  photo app
//
//  Created by Brian Bailey on 3/17/15.
//  Copyright (c) 2015 Patrick Wong. All rights reserved.
//

import UIKit
import Photos

let reuseIdentifier = "photocellID"

class LibraryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, PHPhotoLibraryChangeObserver, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning, SaveDelegate {

    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var onBoardingTextBlock: UIView!
    
    var isPresenting: Bool = true // detects if this is the current view
//    var doneButtonDidPress: Bool = true // user pressed Done button in EditPhotoViewController
    
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
            print("no images loaded")
            self.photoCollectionView.hidden = true
            delay(1.5, closure: { () -> () in
                UIView.animateWithDuration(self.animationLength, animations: { () -> Void in
                    self.onBoardingTextBlock.alpha = 1.0
                })
            })
        } else {
            print("images loaded successfully", appendNewline: false)
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
    
    func doneDidPress(Bool) {
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! PhotoCollectionViewCell
        cell.imageManager = imageManager
        cell.imageAsset = images?.objectAtIndex(indexPath.item) as? PHAsset // configure cell
        return cell
    }
    
    // PHPhotoLibraryChangeObserver
    func photoLibraryDidChange(changeInstance: PHChange) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.images = PHAsset.fetchAssetsWithMediaType(.Image, options: nil)
            if (self.images.count == 0){
                print("no images loaded")
                self.photoCollectionView.hidden = true
            } else {
                print("images loaded successfully", appendNewline: false)
                self.photoCollectionView.hidden = false
            }
            self.photoCollectionView.reloadData()
        })
    }
    
    // tap on photo to segue photo detail view
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("segue to image \(indexPath.item)")
        selectedImage = indexPath.item
        let cellSelection = collectionView.cellForItemAtIndexPath(indexPath)
        cellSelectionFrame = cellSelection?.superview?.convertRect(cellSelection!.frame, toView: nil) //cellSelection?.frame
        
        performSegueWithIdentifier("collectionSegue", sender: self)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "collectionSegue"){
            let controller: EditPhotoViewController = segue.destinationViewController as! EditPhotoViewController
            controller.index = selectedImage
            controller.images = self.images
            controller.imageManager = self.imageManager
            
            controller.modalPresentationStyle = UIModalPresentationStyle.Custom
            controller.transitioningDelegate = self
        }
    }
    
    // custom transitions
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = true
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = false
        return self
    }
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return animationLength
    }
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        print("animating transition")
        let containerView = transitionContext.containerView()
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let movingImage = UIImageView(frame: cellSelectionFrame)
        
        let phAsset = images[selectedImage] as! PHAsset // make a copy of the image
        imageManager.requestImageForAsset(phAsset, targetSize: CGSize(width: 320, height: 320), contentMode: .AspectFill, options: nil) { image, info in
            movingImage.image = image
        }
//        photoCollectionView.addSubview(movingImage)
        
        let window = UIApplication.sharedApplication().keyWindow! // add image to master view
        window.addSubview(movingImage)
    
        
        if (isPresenting) {
            containerView!.addSubview(toViewController.view)
            toViewController.view.alpha = 0
            let editPhotoViewController = toViewController as! EditPhotoViewController
            var libraryEditViewController = fromViewController as! LibraryViewController
            let finalImageView = editPhotoViewController.canvasImage
            
            editPhotoViewController.canvasImage.hidden = true

            UIView.animateWithDuration(animationLength, animations: { () -> Void in
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
            let libraryViewController = toViewController as! LibraryViewController
            let editPhotoViewController = fromViewController as! EditPhotoViewController
            var finalImageView = libraryViewController.cellSelectionFrame
            let startingImageViewFrame = editPhotoViewController.canvasImage.frame
            
            movingImage.contentMode = .ScaleAspectFill
            
            movingImage.frame = startingImageViewFrame
            UIView.animateWithDuration(animationLength/2, animations: { () -> Void in
                fromViewController.view.alpha = 0.0
            })
            UIView.animateWithDuration(animationLength, animations: { () -> Void in
                movingImage.frame = self.cellSelectionFrame
                movingImage.clipsToBounds = libraryViewController.photoCollectionView.clipsToBounds
                
                toViewController.view.alpha = 1
                }) { (finished: Bool) -> Void in
                    transitionContext.completeTransition(true)
                    fromViewController.view.removeFromSuperview()
                    libraryViewController.view.hidden = false
                    editPhotoViewController.view.hidden = true
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