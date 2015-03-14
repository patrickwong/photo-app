//
//  EditPhotoViewController.swift
//  photo app
//
//  Created by Patrick Wong on 3/14/15.
//  Copyright (c) 2015 Patrick Wong. All rights reserved.
//

import UIKit

class EditPhotoViewController: UIViewController {

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

        // Do any additional setup after loading the view.
    }

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

    @IBAction func cancelDidPress(sender: AnyObject) {
        println("does this work")
    }
    
    @IBAction func editControlButtonDidPress(sender: AnyObject) {
        selectedIndex = sender.tag
        sliderControlViewInitial = sliderControlView.center
        editControlHide()
        
        
        if selectedIndex == 0 {

    
            filterLabel.text = "Brightness"
            sliderControlView.center.y = 420
            
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

}
