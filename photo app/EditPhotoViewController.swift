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
    
    var selectedIndex: Int! = 0
    var sliderControlViewInitial: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSlider()
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
        filterLabel.alpha = 0
        editControlHide()
        
        if selectedIndex == 0 {
            filterLabel.text = "Brightness"
            sliderControlView.center.y = 532
            filterLabelShow()
        } else if selectedIndex == 1 {
            filterLabel.text = "Contrast"
            sliderControlView.center.y = 532
            filterLabelShow()
        } else if selectedIndex == 2 {
            filterLabel.text = "Saturation"
            sliderControlView.center.y = 532
            filterLabelShow()
        } else if selectedIndex == 3 {
            filterLabel.text = "Temperature"
            sliderControlView.center.y = 532
            filterLabelShow()
        } else if selectedIndex == 4 {
            filterLabel.text = "Crop & Straigten"
            sliderControlView.center.y = 532
            filterLabelShow()
        }
    }
    
    func editControlHide() {
        doneButton.alpha = 0
        cancelButton.alpha = 0
    }
    
    func editControlShow() {
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
    
    @IBAction func didPressClose(sender: AnyObject) {
        filterLabel.alpha = 0
        editControlShow()
        sliderControlView.center = sliderControlViewInitial
    }
}
