//
//  EditPhotoViewController.swift
//  photo app
//
//  Created by Patrick Wong on 3/14/15.
//  Copyright (c) 2015 Patrick Wong. All rights reserved.
//

import UIKit
import Photos

class EditPhotoViewController: UIViewController {
    
    var images: PHFetchResult! = nil
    var imageManager = PHCachingImageManager() //passed from library controller
    var index : Int! = 0

    @IBOutlet weak var canvasImage: UIImageView!
    @IBOutlet var editControlButtons: [UIButton]!
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var sliderControlView: UIView!
    @IBOutlet weak var editSlider: UISlider!
    @IBOutlet weak var filterLabel: UILabel!
<<<<<<< HEAD
    
=======

    var images: PHFetchResult! = nil
    var imageManager = PHCachingImageManager() //passed from library controller
    var index : Int! = 0
>>>>>>> parent of c44541b... Merge branch 'Slider-Controls'
    var selectedIndex: Int! = 0
    var sliderControlViewInitial: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSlider()
<<<<<<< HEAD
=======
        editControlNames = ["Brightness", "Contrast", "Saturation", "Temperature", "Crop & Straighten"]
        editControlSliderValues = [brightnessValue, contrastValue, saturationValue, temperatureValue, straightenValue]
>>>>>>> parent of c44541b... Merge branch 'Slider-Controls'
    }
    
    override func viewWillAppear(animated: Bool) {
         self.displayImage()
    }
    
    func displayImage(){
        let imageManager = PHImageManager.defaultManager()
        var ID = imageManager.requestImageForAsset(self.images[self.index] as PHAsset, targetSize: PHImageManagerMaximumSize, contentMode: .AspectFit, options: nil, resultHandler: {
            (result, info)->Void in
            self.canvasImage.image = result
        })    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func cancelDidPress(sender: AnyObject) { // send user back to collection view
        println("pressed cancel")
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func editControlButtonDidPress(sender: AnyObject) {
        selectedIndex = sender.tag
        sliderControlViewInitial = sliderControlView.center
        editControlHide()
        
        if selectedIndex == 0 {
            filterLabel.text = "Brightness"
            sliderControlView.center.y = 532
        }
        else if selectedIndex == 1 {
            filterLabel.text = "Contrast"
            sliderControlView.center.y = 532
        }
    }
    
    func editControlHide() {
        filterLabel.alpha = 1
        doneButton.alpha = 0
        cancelButton.alpha = 0
    }
    
    func editControlShow() {
        filterLabel.alpha = 1
        doneButton.alpha = 0
        cancelButton.alpha = 0
    }

    func configureSlider() {
        editSlider.maximumTrackTintColor = UIColor(red: 248/255, green: 253/255, blue: 255/255, alpha: 1)
        editSlider.minimumTrackTintColor = UIColor(red: 248/255, green: 253/255, blue: 255/255, alpha: 1)
        
        let thumbImage = UIImage(named: "slider_knob")
        editSlider.setThumbImage(thumbImage, forState: .Normal)
        
        editSlider.continuous = true
        editSlider.value = 0
        editSlider.maximumValue = 50
        editSlider.minimumValue = -50
    }
<<<<<<< HEAD
}
=======
    
    @IBAction func didPressClose(sender: AnyObject) {
        navBarButtonsShow()
        hideSlider()
    }

    @IBAction func didPressCheckmark(sender: AnyObject) {
        editControlSliderValues[selectedIndex] = editSlider.value
        navBarButtonsShow()
        hideSlider()
    }
    
    @IBAction func didChangeSlider(sender: AnyObject) {
        println(editSlider.value)
    }
}
>>>>>>> parent of c44541b... Merge branch 'Slider-Controls'
