//
//  MapViewController.swift
//  CrowdSurvey
//
//  Created by Colin Gormley on 11/01/2016.
//  Copyright © 2016 Edina. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import ObjectMapper
import Mapbox
import SwiftyJSON
import Siesta

class MapViewController: UIViewController, CLLocationManagerDelegate, ResourceObserver {

    let locationManager = CLLocationManager()
    // TODO: replace with correct url once we have a proxy to dlib-rainbow
    let surveyApiBaseUrl = "https://rawgit.com/ianfieldhouse/4c324db48e0126fdcb8f/raw/fb568a1b602963d3af01880c57f0c4caf2053325/"
    let defaultSurveyId = "566ed9b30351d817555158ce"
    
    var database: CouchBaseUtils?
    var survey: Survey?
    var surveyId: String?

    let statusOverlay = ResourceStatusOverlay()
    

    var surveysResource: Resource? {
        didSet {
            // One call to removeObservers() removes both self and statusOverlay as observers of the old resource,
            // since both observers are owned by self (see below).
            oldValue?.removeObservers(ownedBy: self)
            oldValue?.cancelLoadIfUnobserved(afterDelay: 0.1)
            
            // Adding ourselves as an observer triggers an immediate call to resourceChanged().
            
            surveysResource?.addObserver(self)
                .addObserver(statusOverlay, owner: self)
                .loadIfNeeded()
        }
    }
 
    override func viewDidLayoutSubviews() {
        statusOverlay.positionToCoverParent()
    }
    
    
    // MARK: - Outlets
    @IBOutlet weak var newSurvey: UIButton!{
        didSet{
            newSurvey.layer.cornerRadius = 30
        }
    }
    @IBOutlet weak var mapView: MGLMapView!
    
    
    @IBAction func surveySubmitted(segue:UIStoryboardSegue) {

        print("Submitted")
        
        // TODO: Add map pin?
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        statusOverlay.embedIn(self)
        
        // Get survey resource
        surveysResource = crowdSurveyAPI.surveys
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        self.newSurvey.hidden = true
        self.newSurvey.enabled = false
        
        self.setupMapView()
        self.database = self.setupDatabase()
    }
    
    // MARK: - Siesta Delegate
    // Listen for SurveysResource changing.
    func resourceChanged(resource: Resource, event: ResourceEvent) {
        
        // Only do stuff if there is new data
        if case .NewData = event {
            setupSurvey()
        }
    }

    
     // MARK: - Setup
    func setupMapView(){
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        mapView.showsUserLocation = true
        
        self.view.bringSubviewToFront(self.newSurvey)
    }
    
    func setupDatabase() -> CouchBaseUtils {
        return CouchBaseUtils(databaseName: "survey")
    }
    
    
    func createActiveSurveyModel(doc : CBLDocument){
        
        self.survey = Mapper<Survey>().map(doc.properties)
        self.database!.setActiveFlag(doc)
        self.newSurvey.hidden = false
        self.newSurvey.enabled = true
    }
    
    func setupSurvey(){
        
        if let surveys = surveysResource?.latestData?.content{
            
            var surveyFound = false
            let surveysJson = (surveys as! JSON)
            
            // Iterate over surveys and add to database if not already added
            for (index, surveyJson):(String, JSON) in surveysJson {
   
                if let database = self.database {
                    if let doc = database.getOrCreateDocument(surveyJson) {
                        
                        // Check if we need to load a specific survey
                        if let surveyId = self.surveyId {
                            
                            if surveyId == surveyJson["id"].stringValue{
                                
                                surveyFound = true
                                
                                createActiveSurveyModel(doc)
                            }
                        }
                    }
                }
            }
            
            
            // If we weren't looking for a specific survey, assume we just load the first one as default
            if !surveyFound {
                
                //load default survey
                
                if surveysJson.count > 0{
                    
                    let defaultSurveyId = surveysJson[0]["id"].stringValue
                    
                    // Load survey from db based on this id
                    if let database = self.database {
                        if let doc = database.getDocumentById(defaultSurveyId) {
                           createActiveSurveyModel(doc)
                        }
                    }
                }
            }
        }
        
        
        
        /*var surveyUrl: String!
        
        if let surveyId = self.surveyId {
            surveyUrl = "\(self.surveyApiBaseUrl)\(surveyId).json"
        } else {
            // no survey id specified so load default survey
            self.showAlert("No survey specified", message: "Loading the default survey.")
            surveyUrl = "\(self.surveyApiBaseUrl)\(self.defaultSurveyId).json"
        }*/
        
        // retrieve JSON representing a survey
        /*Alamofire.request(.GET, surveyUrl)
            .responseJSON { response in
                if response.result.isSuccess {
                    if let jsonData = response.result.value {
                        if let database = self.database {
                            if let doc = database.getOrCreateDocument(JSON(jsonData)) {
                                database.setActiveFlag(doc)
                                self.survey = Mapper<Survey>().map(doc.properties)
                            }
                        }
                        self.newSurvey.hidden = false
                        self.newSurvey.enabled = true
                    }
                } else {
                    self.showAlert("Not found", message: "The survey you are trying to access isn't available.")
                }
        }*/
    }
    
    func showAlert(title: String, message: String){
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: nil))
        if let navigationController = self.navigationController {
            navigationController.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        if segue.identifier == "Show Survey" {
            if let destinationVC = segue.destinationViewController as? SurveyViewController {
                destinationVC.survey = survey
                if let s = destinationVC.survey {
                    s.location = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
                }
                destinationVC.database = self.database!
            }
        }
    }

    @IBAction func returnToMapViewController(segue:UIStoryboardSegue) {
         //unwind segue
    }

}
