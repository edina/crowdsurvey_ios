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

class MapViewController: UIViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    // TODO: replace with correct url once we have a proxy to dlib-rainbow
    let surveyApiBaseUrl = "https://rawgit.com/ianfieldhouse/4c324db48e0126fdcb8f/raw/fb568a1b602963d3af01880c57f0c4caf2053325/"
    let defaultSurveyId = "566ed9b30351d817555158ce"
    
    var database: CouchBaseUtils?
    var mapView: MGLMapView?
    var survey: Survey?
    var surveyId: String?
    
    // MARK: - Outlets
    
    @IBOutlet weak var newSurvey: UIButton!{
        didSet{
            newSurvey.layer.cornerRadius = 30
        }
    }
    
    @IBOutlet weak var toolbar: UIToolbar!
    
    @IBAction func surveySubmitted(segue:UIStoryboardSegue) {

        print("Submitted")
        
        // TODO: Add map pin?
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.newSurvey.hidden = true
        self.newSurvey.enabled = false
        
        self.setupMapView()
        self.database = self.setupDatabase()
        self.setupSurvey()
    }
    
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
        
        let styleURL = NSURL(string: "mapbox://styles/mapbox/streets-v8")
        
        let frame = self.view.bounds
        let edgeInsets = UIEdgeInsetsMake(0, 0, self.toolbar.bounds.height, 0);
        let insetFrame = UIEdgeInsetsInsetRect(frame, edgeInsets);
        self.mapView = MGLMapView(frame: insetFrame, styleURL: styleURL)
        
        if let mapView = self.mapView {
            mapView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            mapView.setCenterCoordinate(CLLocationCoordinate2D(latitude: 57.153468223320054,
                longitude: -3.8228130340576167),
                zoomLevel: 14, animated: false)
            mapView.showsUserLocation = true
            self.view.addSubview(mapView)
        }
        self.view.bringSubviewToFront(self.newSurvey)
    }
    
    func setupDatabase() -> CouchBaseUtils {
        return CouchBaseUtils(databaseName: "survey")
    }
    
    func setupSurvey(){
        var surveyUrl: String!
        
        if let surveyId = self.surveyId {
            surveyUrl = "\(self.surveyApiBaseUrl)\(surveyId).json"
        } else {
            // no survey id specified so load default survey
            self.showAlert("No survey specified", message: "Loading the default survey.")
            surveyUrl = "\(self.surveyApiBaseUrl)\(self.defaultSurveyId).json"
        }
        
        // retrieve JSON representing a survey
        Alamofire.request(.GET, surveyUrl)
            .responseJSON { response in
                if response.result.isSuccess {
                    if let jsonData = response.result.value {
                        if let database = self.database {
                            if let doc = database.getOrCreateDocument(jsonData) {
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
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        if segue.identifier == "Show Survey" {
            if let destinationVC = segue.destinationViewController as? SurveyViewController {
                destinationVC.survey = survey
                destinationVC.database = self.database!
            }
   
        }
    }

    @IBAction func returnToMapViewController(segue:UIStoryboardSegue) {
         //unwind segue
    }

}
