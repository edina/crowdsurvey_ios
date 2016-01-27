//
//  SurveyViewController.swift
//  CrowdSurvey
//
//  Created by Colin Gormley on 12/01/2016.
//  Copyright © 2016 Edina. All rights reserved.
//

import UIKit
import Eureka



class SurveyViewController: FormViewController {

    var survey: Survey? { didSet { setupForm() } }
   
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setupForm(){
        form = survey!.form()
    }
    
    @IBAction func save(sender: UIBarButtonItem) {
        
        // Perform form validation
        if survey!.validateFormEntries(){
            
            // Append to records
            survey!.records!.append(Record(survey: survey!))
            
            // All valid so we can unwind to the MapViewController
            performSegueWithIdentifier("saveSurvey", sender: self)
        }else{
            
            let alert = UIAlertController(title: "Survey Incomplete", message: "All required fields have not been completed", preferredStyle: UIAlertControllerStyle.Alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            
            // show the alert
            self.presentViewController(alert, animated: true, completion: nil)
            
            

        }
        
      
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
