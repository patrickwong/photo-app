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
    
    @IBOutlet weak var canvasImage: UIImageView!
    @IBOutlet var editControlButtons: [UIButton]!
    @IBOutlet weak var editControlContainer: UIView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var sliderControlView: UIView!
    @IBOutlet weak var editSlider: UISlider!
    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var sliderValueOverlay: UILabel!

    var images: PHFetchResult! = nil
    var imageManager = PHCachingImageManager() //passed from library controller
    var index : Int! = 0
    var selectedIndex: Int! = 0
    var editControlNames: [String]!
    var editControlSliderValues: [Float]! = []
    var brightnessValue: Float! = 0
    var contrastValue: Float! = 0
    var saturationValue: Float! = 0
    var temperatureValue: Float! = 0
    var straightenValue: Float! = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSlider()
        editControlNames = ["Brightness", "Contrast", "Saturation", "Temperature", "Crop & Straighten"]
        editControlSliderValues = [brightnessValue, contrastValue, saturationValue, temperatureValue, straightenValue]
        sliderValueOverlay.alpha = 0
        sliderValueOverlay.layer.shadowRadius = 6
        sliderValueOverlay.layer.shadowOpacity = 0.1
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
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func doneDidPress(sender: AnyObject) {
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
    
    func showSlider(){
        editControlContainer.alpha = 0
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.sliderControlView.alpha = 1
        })
    }
    
    func hideSlider(){
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
        editSlider.maximumValue = 50
        editSlider.minimumValue = -50
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
    
    @IBAction func didChangeSlider(sender: AnyObject) {
        sliderValueOverlay.text = "\(Int(editSlider.value))"
        if editSlider.tracking == true {
            self.sliderValueOverlay.alpha = 1
        } else {
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.sliderValueOverlay.alpha = 0
            })
        }
    }
}