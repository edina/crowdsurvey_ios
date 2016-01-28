//
//  MapViewController.swift
//  CrowdSurvey
//
//  Created by Colin Gormley on 11/01/2016.
//  Copyright © 2016 Edina. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Alamofire
import ObjectMapper
import SwiftyJSON

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    // TODO: replace with correct url once we have a proxy to dlib-rainbow
    let surveyApiBaseUrl = "https://rawgit.com/ianfieldhouse/4c324db48e0126fdcb8f/raw/fb568a1b602963d3af01880c57f0c4caf2053325/"
    let defaultSurveyId = "566ed9b30351d817555158ce"
    
    var database: CouchBaseUtils?
    var survey: Survey?
    var surveyId: String?
    
    // MARK: - Outlets
    
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            // Set delegate for Map
            mapView.delegate = self
        }
    }
    
    @IBOutlet weak var newSurvey: UIButton!{
        didSet{
            newSurvey.layer.cornerRadius = 30
        }
    }
    
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
        
        // Setup alternative tile server
        let template = "https://tile.thunderforest.com/landscape/{z}/{x}/{y}.png"
        let overlay = MKTileOverlay.init(URLTemplate: template)
        overlay.canReplaceMapContent = true
        mapView.addOverlay(overlay, level: .AboveLabels)
        mapView.showsUserLocation = true
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
        self.presentViewController(alert, animated: true, completion: nil)

    }
    
    
    // MARK: - MKMapViewDelegate
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        guard let tileOverlay = overlay as? MKTileOverlay else {
            return MKOverlayRenderer()
        }
        return MKTileOverlayRenderer(tileOverlay: tileOverlay)
    }
    
    // MARK: - CLLocationManager
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.mapView.setRegion(region, animated: true)
    }

    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        if segue.identifier == "Show Survey" {
            if let destinationVC = segue.destinationViewController as? SurveyViewController {
                destinationVC.survey = survey
            }
   
        }
    }


}
