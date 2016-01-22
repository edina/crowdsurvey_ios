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
    var database: CBLDatabase!
    var survey: Survey?
    
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
        // Survey has been completed
        survey!.records!.append(Record(survey: survey!))
        print("Submitted")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.newSurvey.hidden = true
        self.newSurvey.enabled = false

        self.setupMapView()
        self.setupDatabase()
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
    
    func setupDatabase(){
        let manager = CBLManager.sharedInstance()
        
        do {
            try database = manager.databaseNamed("survey")
        } catch {
            print("Can't access database")
        }
    }
    
    func setupSurvey(){
        // retrieve JSON representing a survey
        // TODO: replace with correct url once we have a proxy to dlib-rainbow
        let survey_url = "https://rawgit.com/ianfieldhouse/4c324db48e0126fdcb8f/raw/e65e1cc390d9809fda6503fc98d9c9b0a12ee7e1/"
        
        Alamofire.request(.GET, survey_url)
            .responseJSON { response in
                if response.result.isSuccess {
                    if let jsonData = response.result.value {
                        let doc = self.getOrCreateDocument(jsonData)
                        self.survey = Mapper<Survey>().map(doc.properties)
                        self.newSurvey.hidden = false
                        self.newSurvey.enabled = true
                    }
                } else {
                    self.showAlert("Not found", message: "The survey you are trying to access isn't available.")
                }
        }
    }
    
    func getOrCreateDocument(jsonData: AnyObject) -> CBLDocument {
        let json = JSON(jsonData)
        let id = json["id"].string
        var doc: CBLDocument!
        
        if let docId = id {
            doc = self.database.existingDocumentWithID(docId)
            if doc == nil {
                doc = self.database.documentWithID(docId)
                do{
                    try doc!.putProperties(jsonData as! [String : AnyObject])
                    print("Saved document id ", docId)
                }catch{
                    print("Error adding document")
                }
            }
        } else {
            self.showAlert("Storage error", message: "The survey you are trying to access can't be saved to your device.")
        }
        
        return doc
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
