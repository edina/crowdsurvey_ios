//
//  PhotoViewController.swift
//  DFS
//
//  Created by Colin Gormley on 16/05/2016.
//  Copyright © 2016 Edina. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate  {
    
    
    var images = [UIImage]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    @IBOutlet weak var closeButton: UIButton!{
        didSet{
            closeButton.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_4))
        }
    }
    
    @IBAction func dismiss(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    @IBAction func goToCameraRoll(sender: AnyObject) {
        self.cameraRoll()
    }

    @IBAction func takePhoto(sender: AnyObject) {
        self.openCamera()
    }
    
    func openCamera()
    {
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            //load the camera interface
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }else{
            //no camera available
            let alert = UIAlertController(title: "Error", message: "There is no camera available", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .Default, handler: {(alertAction)in
                alert.dismissViewControllerAnimated(true, completion: nil)
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func cameraRoll() {
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.SavedPhotosAlbum) {
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType =
                UIImagePickerControllerSourceType.PhotoLibrary
         
            imagePicker.allowsEditing = false
            self.presentViewController(imagePicker, animated: true,
                                       completion: nil)
        }

    }
    
    
    
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
       
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            picker.dismissViewControllerAnimated(true, completion: nil)
            images.append(image)
            
            self.collectionView.reloadData()
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        print(segue.identifier)
        if segue.identifier == Constants.SegueIDs.showPhoto {
            if let imvc = segue.destinationViewController as? ImageViewController{
                
                if let indexPath = collectionView.indexPathsForSelectedItems(){
                    let r = self.images[indexPath[0].row] as UIImage
           
                    imvc.image =  r
                }
            }
        }
        
     }
    
}






extension PhotoViewController : UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Constants.ReuseIDs.photoCell,forIndexPath:indexPath) as! CustomCollectionViewCell
        
        
        let image  = self.images[indexPath.item]
        cell.imageView.image = image
        
//        cell.caption.text = "This is some caption text"

        
        return cell
    }
    
//    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
//        
//        let headerView: FruitsHeaderView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: headerViewIdentifier, forIndexPath: indexPath) as! FruitsHeaderView
//        
//        headerView.sectionLabel.text = dataSource.gettGroupLabelAtIndex(indexPath.section)
//        
//        return headerView
//    }
}

// MARK:- UICollectionViewDelegate Methods

extension PhotoViewController : UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        highlightCell(indexPath, flag: true)
        // handle tap events
//        performSegueWithIdentifier(Constants.SegueIDs.showPhoto, sender: indexPath)
    }
//
//    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
//        highlightCell(indexPath, flag: false)
//    }
}

extension PhotoViewController: UICollectionViewDelegateFlowLayout {
    // MARK:- UICollectioViewDelegateFlowLayout methods
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        // http://stackoverflow.com/questions/28872001/uicollectionview-cell-spacing-based-on-device-sceen-size
        
        let length = (UIScreen.mainScreen().bounds.width-15)/2
        return CGSizeMake(length,length);
    }
}
