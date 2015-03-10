//
//  PhotoCollectionViewController.swift
//  Photo App
//
//  Created by Brian Bailey on 3/9/15.
//  Copyright (c) 2015 Patrick Wong. All rights reserved.
//

import UIKit

class PhotoCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {

    @IBOutlet weak var collectionView: UICollectionView!
        
    let reuseIdentifier = "photoCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // UICollectionViewDataSource required methods
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // placeholder since we haven't actually implemented photo framework
        return 3; // number of photos in album we currently have
        // number of cells that we need to create are the number that are in the album we currently have
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // gets cell and creates it, displaying it on the view controller
        let cell: UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as UICollectionViewCell
        
        // modify the cell
        cell.backgroundColor = UIColor.redColor()
        
        return cell
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
