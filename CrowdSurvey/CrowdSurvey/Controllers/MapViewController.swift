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

class MapViewController: UIViewController, CLLocationManagerDelegate, MGLMapViewDelegate, ResourceObserver {

    let locationManager = CLLocationManager()
 
    // Simple default survey to be loaded if no other id explicitly specified 
    let defaultSurveyId = "566ed9b30351d817555158ce"
    
    var database: CouchBaseUtils?
    var survey: Survey?
    var surveyId: String?

    var surveys: [Survey] = []
    
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
    
    @IBOutlet weak var navbarTitle: UINavigationItem!
    
    @IBAction func surveySubmitted(segue:UIStoryboardSegue) {
        print("Submitted")
        if let record = self.survey?.records?.last {
            addAnnotationToMap(record)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Get survey resource
        surveysResource = crowdSurveyAPI.surveys
        
        statusOverlay.embedIn(self)
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
        // Set the map view‘s delegate property
        mapView.delegate = self
        
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
    
    func createActiveSurveyModelForID(id : String){
        self.database?.setActiveFlagForId(id)
        self.newSurvey.hidden = false
        self.newSurvey.enabled = true
        navbarTitle.title = self.survey?.title
    }
    
    func loadDefaultSurvey(){
        // Get the default survey
        if let defaultSurvey = self.surveys.filter({$0.id == defaultSurveyId}).first {
            self.survey = defaultSurvey
            createActiveSurveyModelForID(defaultSurveyId)
        }
    }
    
    func addSurveysToDB(surveyJson : JSON) -> Bool{
        
        var surveyFound = false
        
        if let doc = self.database?.getOrCreateDocument(surveyJson){
            
            let newSurvey = Mapper<Survey>().map(doc.properties)!
            
            // Only add survey to array if not already there
            if(!self.surveys.contains(newSurvey)){
                self.surveys.append(newSurvey)
            }
            
            // Check if we need to load a specific survey
            if self.surveyId == surveyJson["id"].stringValue{
                surveyFound = true
                self.survey = newSurvey
                createActiveSurveyModelForID(self.surveyId!)
                self.surveyId = nil // Reset survey id - survey is loaded in self.survey anyway
            }
        }
        return surveyFound
    }
    
    
    func setupSurvey(){
        
        // Get surveys json
        if let surveysJson = surveysResource?.latestData?.content as? JSON{
            
            // Only update our models and db if there are more surveys on the server
            if ((surveysJson.count > self.surveys.count) || (self.surveyId?.isEmpty != nil)){
           
                var surveyFound = false
                
                // Iterate over surveys and add to database if not already added
                for (index, surveyJson):(String, JSON) in surveysJson {
  
                    surveyFound = addSurveysToDB(surveyJson)
                }

                // If we weren't looking for a specific survey, assume we just load the default
                if !surveyFound {
                    loadDefaultSurvey()
                }
            }
            
            removeAllAnnotations()
            // Add annotations to map for any existing survey responses 
            for record: Record in (survey?.records)! {
                addAnnotationToMap(record)
            }
        }
    }
    
    // MARK: - Utility
    
    func addAnnotationToMap(record: Record){
        if let state = record.state where state != Record.RecordState.New {
            let pin = MGLPointAnnotation()
            pin.title = state.rawValue
            let recordJSON = record.description
            if let dataFromString = recordJSON.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                let json = JSON(data: dataFromString)
                let lat = json["geometry"]["coordinates"][1].double
                let lon = json["geometry"]["coordinates"][0].double
                if let lat = lat, lon = lon {
                    pin.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                }
                mapView.addAnnotation(pin)
            }
        }
    }
    
    func removeAllAnnotations(){
        if let annotations = self.mapView.annotations{
            self.mapView.removeAnnotations(annotations)
            
        }
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
    
    // MARK: - MGLMapView Delegate
    
    func mapView(mapView: MGLMapView, imageForAnnotation annotation: MGLAnnotation) -> MGLAnnotationImage? {
        var annotationImage: MGLAnnotationImage?
        var image: UIImage!
        var reuseIdentifier: String!
        if let title = annotation.title {
            if title == Record.RecordState.Incomplete.rawValue {
                image = UIImage(named: "Map Marker (incomplete)")!
                reuseIdentifier = Record.RecordState.Incomplete.rawValue
            } else if title == Record.RecordState.Complete.rawValue {
                image = UIImage(named: "Map Marker (complete)")!
                reuseIdentifier = Record.RecordState.Complete.rawValue
            } else if title == Record.RecordState.Submitted.rawValue {
                image = UIImage(named: "Map Marker (submitted)")!
                reuseIdentifier = Record.RecordState.Submitted.rawValue
            }
        }
        // Initialize the ‘map pin’ annotation image with the UIImage we just loaded
        annotationImage = MGLAnnotationImage(image: image, reuseIdentifier: reuseIdentifier)
        return annotationImage
    }
    
    func mapView(mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        // Always allow callouts to popup when annotations are tapped
        return true
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        if segue.identifier == Constants.SegueIDs.ShowSurvey {
            if let surveyVC = segue.destinationViewController as? SurveyViewController {
                
                // Ensure back button text is "Back" rather than the Survey title
                let backItem = UIBarButtonItem()
                backItem.title = "Back"
                navigationItem.backBarButtonItem = backItem //
                
                
                if let survey = survey {
                    surveyVC.survey = survey
                    
                    // TODO Load existing record if it exists, or
                    // Create new Record for this Survey
                    let record = Record(survey: survey, location: CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude))
                    surveyVC.survey?.records?.append(record)
                }
                surveyVC.database = self.database!
            }
            
        }else if segue.identifier == Constants.SegueIDs.ShowSurveyList {
         
            // Destination is NavigationViewController - we want the subsequent SurveyListTableViewController
            if let navVC = segue.destinationViewController as? UINavigationController{
                
                if let surveyListVC = navVC.viewControllers.first as? SurveyListTableViewController {
                    // Set survey list
                    surveyListVC.surveys = self.surveys
                }
            }
        }
    }

    @IBAction func returnToMapViewController(segue:UIStoryboardSegue) {
         //unwind segue
        
        let id = self.survey?.id
        self.createActiveSurveyModelForID(id!)
        self.removeAllAnnotations()
        
        for record: Record in (survey?.records)! {
            addAnnotationToMap(record)
        }
    }

}
