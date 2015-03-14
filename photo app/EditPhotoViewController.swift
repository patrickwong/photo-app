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
    var selectedIndex: Int! = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    }
    
    @IBAction func editControlButtonDidPress(sender: AnyObject) {
        selectedIndex = sender.tag
        println(selectedIndex)
    }
}
