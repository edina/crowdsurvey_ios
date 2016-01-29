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
    var database: CouchBaseUtils?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Listen out for Field changing
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "listenForFieldChange:", name:Constants.Notifications.FieldUpdatedNotification, object: nil)
    }
    
    func listenForFieldChange(notification: NSNotification){
        // A field has changed so the survey should be resaved
        print("Field change notification")
        self.database!.saveUpdatedSurvey((self.survey?.jsonDict())!)
    }
    
    func setupForm(){
        form = survey!.form()
    }
    
    @IBAction func save(sender: UIBarButtonItem) {
        
        // Perform form validation
        if survey!.validateFormEntries(){
            
            // Append to records
            let record  = Record(survey: survey!)
            survey!.records!.append(record)
            
            self.database!.saveUpdatedSurveyRecords((self.survey?.jsonDict())!)
            
            // All valid so we can unwind to the MapViewController
            performSegueWithIdentifier("saveSurvey", sender: self)
        }else{
            
            let alert = UIAlertController(title: "Survey Incomplete", message: "Please ensure all required fields have been completed.", preferredStyle: UIAlertControllerStyle.Alert)
            
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
