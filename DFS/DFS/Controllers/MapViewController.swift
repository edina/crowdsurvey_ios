//
//  MapViewController.swift
//  DFS
//
//  Created by Colin Gormley on 12/05/2016.
//  Copyright © 2016 Edina. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {

    // MARK: Variables
    
    
    @IBOutlet weak var addPhotoButton: UIButton!{
        didSet{
            addPhotoButton.layer.cornerRadius = 30
            addPhotoButton.layer.shadowColor = UIColor.blackColor().CGColor
            addPhotoButton.layer.shadowOffset = CGSizeMake(2, 2)
            addPhotoButton.layer.shadowRadius = 5
            addPhotoButton.layer.shadowOpacity = 0.5
            addPhotoButton.setTitleColor(Constants.Colour.LightBlue, forState: UIControlState.Normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
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
