//
//  PhotoViewController.swift
//  DFS
//
//  Created by Colin Gormley on 16/05/2016.
//  Copyright © 2016 Edina. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {
    

 
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
// dismissViewControllerAnimated(true, completion: nil)
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
