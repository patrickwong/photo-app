//
//  CameraRollViewController.swift
//  Photo App
//
//  Created by Brian Bailey on 3/2/15.
//  Copyright (c) 2015 Patrick Wong. All rights reserved.
//

import UIKit

class CameraRollViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var photoImageView = UIImageView(frame: CGRectMake(40, 120, 200, 200)) // size and place of selected image
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(photoImageView) // add imageView to view

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func photoLibraryButtonDidPress(sender: AnyObject) {
        var imagePicker = UIImagePickerController()
        imagePicker.delegate = self // Needs UIImagePickerControllerDelegate, UINavigationControllerDelegate to build
        imagePicker.sourceType = .PhotoLibrary // source can be Camera, SavedPhotosAlbum, and PhotoLibrary
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]){
        photoImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage // present selected photoLibrary image
        self.dismissViewControllerAnimated(false, completion: nil) // close photoLibrary after selection
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
