//
//  EditPhotoViewController.swift
//  photo app
//
//  Created by Patrick Wong on 3/14/15.
//  Copyright (c) 2015 Patrick Wong. All rights reserved.
//

import UIKit
import Photos
import AssetsLibrary

protocol SaveDelegate {
    func doneDidPress(Bool)
}

class EditPhotoViewController: UIViewController {
    
    @IBOutlet weak var canvasImage: UIImageView!
    @IBOutlet var editControlButtons: [UIButton]!
    @IBOutlet weak var editControlContainer: UIView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var sliderControlView: UIView!
    @IBOutlet weak var editSlider: UISlider!
    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var sliderValueOverlay: UILabel!
    @IBOutlet weak var sliderValueLabel: UILabel!
    
    var images: PHFetchResult! = nil
    var imageManager = PHCachingImageManager() //passed from library controller
    var index : Int! = 0 // image IndexPath
    var delegate:SaveDelegate? = nil
    
    var selectedIndex: Int! = 0
    var editControlNames: [String]!
    var editControlSliderValues: [Float]! = []
    var brightnessValue: Float! = 0
    var contrastValue: Float! = 0
    var saturationValue: Float! = 0
    var temperatureValue: Float! = 0
    var straightenValue: Float! = 0
    var thumbRect: CGRect!
    var trackRect: CGRect!
    var sliderValueLabelInitialY: CGFloat!
    var context: CIContext!
    var filter: CIFilter!
    var beginImage: CIImage!
    var orientation: UIImageOrientation = .Up
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSlider()
        editControlNames = ["Brightness", "Contrast", "Saturation", "Temperature", "Crop & Straighten"]
        editControlSliderValues = [brightnessValue, contrastValue, saturationValue, temperatureValue, straightenValue]
        sliderValueLabel.alpha = 0
        sliderValueOverlay.alpha = 0
        sliderValueOverlay.layer.shadowRadius = 6
        sliderValueOverlay.layer.shadowOpacity = 0.1
        sliderValueLabelInitialY = sliderValueLabel.center.y
    }
    
    override func viewWillAppear(animated: Bool) {
         self.displayImage()
    }
    
    func displayImage(){
        let imageManager = PHImageManager.defaultManager()
        var ID = imageManager.requestImageForAsset(self.images[self.index] as! PHAsset, targetSize: PHImageManagerMaximumSize, contentMode: .AspectFit, options: nil, resultHandler: {
            (result, info)->Void in
            self.canvasImage.image = result
            
            // Get image orientation & create CIImage
            self.orientation = result!.imageOrientation
            self.beginImage = CIImage(image: self.canvasImage.image!)
            //Set filter values
            self.filter = CIFilter(name: "CIExposureAdjust")
            self.filter.setValue(self.beginImage, forKey: kCIInputImageKey)
            self.filter.setValue(0, forKey: kCIInputEVKey)
            // Create context
            self.context = CIContext(options:nil)
            // Create image copy with filter applied
            let cgimg = self.context.createCGImage(self.filter.outputImage, fromRect: self.filter.outputImage.extent)
            // Update image with filtered copy
            let newImage = UIImage(CGImage: cgimg, scale: 1, orientation: self.orientation)
            self.canvasImage.image = newImage
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func cancelDidPress(sender: AnyObject) { // send user back to collection view
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func doneDidPress(sender: AnyObject) {
        print("Saving images does not work in Simulator. Try testing the feature on a device.")
//        let imageToSave = filter.outputImage
//        let softwareContext = CIContext(options:[kCIContextUseSoftwareRenderer: true])
//        let cgimg = softwareContext.createCGImage(imageToSave, fromRect:imageToSave.extent())
//        let library = ALAssetsLibrary()
//        library.writeImageToSavedPhotosAlbum(cgimg,
//            metadata:imageToSave.properties(),
//            completionBlock:nil)
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func editControlButtonDidPress(sender: AnyObject) {
        selectedIndex = sender.tag
        filterLabel.alpha = 0
        navBarButtonsHide()
        showSlider()
        filterLabelShow()
        filterLabel.text = editControlNames[selectedIndex]
        sliderControlView.center.y = 36
        editSlider.value = editControlSliderValues[selectedIndex]
        sliderValueLabel.text = "\(Int(editSlider.value * 100 / 2))"
        // Get thumb rect and set slider label center to thumb center
        thumbRect = editSlider.thumbRectForBounds(self.editSlider.bounds, trackRect: self.editSlider.frame, value: self.editSlider.value)
        sliderValueLabel.center.x = thumbRect.midX
        // Hide slider label when value is 0
        if sliderValueLabel.text == "0"{
            sliderValueLabel.alpha = 0
        }
        else {
            sliderValueLabel.alpha = 1
        }
    }
    
    func navBarButtonsHide() {
        doneButton.alpha = 0
        cancelButton.alpha = 0
    }
    
    func navBarButtonsShow() {
        UIView.animateWithDuration(0.35, animations: { () -> Void in
            self.doneButton.alpha = 1
            self.cancelButton.alpha = 1
        })
    }
    
    func filterLabelShow() {
        UIView.animateWithDuration(0.35, animations: { () -> Void in
            self.filterLabel.alpha = 1
        })
    }
    
    func showSlider() {
        editControlContainer.alpha = 0
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.sliderControlView.alpha = 1
        })
    }
    
    func hideSlider() {
        sliderControlView.alpha = 0
        filterLabel.alpha = 0
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.editControlContainer.alpha = 1
        })
    }

    func configureSlider() {
        editSlider.maximumTrackTintColor = UIColor(red: 248/255, green: 253/255, blue: 255/255, alpha: 1)
        editSlider.minimumTrackTintColor = UIColor(red: 248/255, green: 253/255, blue: 255/255, alpha: 1)
        let leftTrackImage = UIImage(named: "left-track")
        let rightTrackImage = UIImage(named: "right-track")
        let thumbImage = UIImage(named: "slider_knob")
        editSlider.setMinimumTrackImage(leftTrackImage, forState: .Normal)
        editSlider.setMaximumTrackImage(rightTrackImage, forState: .Normal)
        editSlider.setThumbImage(thumbImage, forState: .Normal)
        editSlider.continuous = true
        editSlider.value = 0
        editSlider.maximumValue = 1
        editSlider.minimumValue = -1
    }
    
    @IBAction func didPressClose(sender: AnyObject) {
        navBarButtonsShow()
        hideSlider()
    }

    @IBAction func didPressCheckmark(sender: AnyObject) {
        editControlSliderValues[selectedIndex] = editSlider.value
        navBarButtonsShow()
        hideSlider()
    }
    
    @IBAction func didChangeSlider(sender: UISlider) {
        let sliderValueLabelNewY = sliderValueLabelInitialY - 5
        sliderValueLabel.text = "\(Int(editSlider.value * 100 / 2))"
        sliderValueOverlay.text = "\(Int(editSlider.value * 100 / 2))"
        
        // Get thumb rect and set slider label center to thumb center
        thumbRect = editSlider.thumbRectForBounds(self.editSlider.bounds, trackRect: self.editSlider.frame, value: self.editSlider.value)
        sliderValueLabel.center.x = thumbRect.midX
        
        //Filter image per slider value
        let sliderValue = sender.value
        filter.setValue(sliderValue, forKey: kCIInputEVKey)
        let outputImage = filter.outputImage
        let cgimg = context.createCGImage(outputImage, fromRect: outputImage.extent)
        let newImage = UIImage(CGImage: cgimg, scale: 1, orientation: self.orientation)
        self.canvasImage.image = newImage
        
        // Conditional for displaying value labels
        if editSlider.tracking == true {
            self.sliderValueOverlay.alpha = 1
            self.sliderValueLabel.alpha = 1
            UIView.animateWithDuration(0.20, animations: { () -> Void in
                self.sliderValueLabel.center.y = sliderValueLabelNewY
            })
        } else {
            UIView.animateWithDuration(0.35, delay: 0, usingSpringWithDamping: 0.65, initialSpringVelocity: 0, options: [], animations: { () -> Void in
                self.sliderValueLabel.center.y = self.sliderValueLabelInitialY
            }, completion: nil)
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.sliderValueOverlay.alpha = 0
                // Fade out slider label when value is 0
                if self.sliderValueLabel.text == "0" {
                    self.sliderValueLabel.alpha = 0
                }
            })
        }
    }
}