//
//  ImageViewController.swift
//  DFS
//
//  Created by Colin Gormley on 17/05/2016.
//  Copyright © 2016 Edina. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    var image: UIImage?
    
    @IBOutlet weak var imageView: UIImageView!
    
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
        
        imageView.image = image


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

}
