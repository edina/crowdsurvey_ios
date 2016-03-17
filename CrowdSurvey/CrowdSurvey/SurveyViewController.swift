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


    @IBOutlet weak var closeButton: UIButton! {
        didSet{
            closeButton.layer.cornerRadius = 30
        }
    }
    
    var survey: Survey?
    var database: CouchBaseUtils?
    

    @IBAction func close(sender: AnyObject) {
        
        if let survey = self.survey?.records?.last {
            
            // If the record was empty, we can safely remove it
            if survey.state == Record.RecordState.New {
                self.survey?.records?.removeLast()
            }
            
            self.saveToDatabase()
        }
        
        // This ensures that the returnToMapViewController IBAction in MapViewController gets callesd
        self.performSegueWithIdentifier(Constants.SegueIDs.SaveSurvey, sender: self)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        setupForm()
        
        closeButton.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_4))
        self.view.bringSubviewToFront(self.closeButton)
        // Listen out for Field changing
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "listenForFieldChange:", name:Constants.Notifications.FieldUpdatedNotification, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        UIApplication.sharedApplication().setStatusBarStyle(.Default, animated: true)
    }

    
    
    
    func listenForFieldChange(notification: NSNotification){
        // A field has changed so the survey should be resaved
        print("Field change notification")
        self.database!.saveUpdatedSurvey((self.survey?.jsonDict())!)
    }
    
    func setupForm(){
        let currentRecord = survey?.records?.last
        if  let record = currentRecord {
            form = record.form()
        }
    }
    
    @IBAction func save(sender: UIBarButtonItem) {
        
        // Perform form validation
        let currentRecord = survey?.records?.last
        
        
        if let record = currentRecord {
            
            let recordState = record.state ?? Record.RecordState.Incomplete
            
            switch recordState {
                
            case Record.RecordState.Incomplete:
         
                // Show alert
                self.showAlert()
                
            case Record.RecordState.Complete:
                
                // All valid so we can unwind to the MapViewController
                performSegueWithIdentifier(Constants.SegueIDs.SaveSurvey, sender: self)
                
            case Record.RecordState.New:
                // Show alert
                self.showAlert()
                
            case Record.RecordState.Submitted:
                print("Submitted")
                // Shouldn't get here
            }
        }
    }
    
    
    func saveToDatabase() {       
        self.database?.saveUpdatedSurveyRecords((self.survey?.jsonDict())!)
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Survey Incomplete", message: "Please ensure all required fields have been completed.", preferredStyle: UIAlertControllerStyle.Alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        
        // show the alert
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Navigation

    
    override func willMoveToParentViewController(parent: UIViewController?) {
        super.willMoveToParentViewController(parent)
        if parent == nil {
            
            if let survey = self.survey?.records?.last {

                // If the record was empty, we can safely remove it
                if survey.state == Record.RecordState.New {
                    self.survey?.records?.removeLast()
                }
                
                self.saveToDatabase()
            }
        }
    }
    
    
    
    /*// In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }*/


}
