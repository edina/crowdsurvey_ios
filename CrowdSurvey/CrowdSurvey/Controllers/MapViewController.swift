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

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
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
            newSurvey.layer.cornerRadius = 15
        }
    }
    
    @IBAction func surveySubmitted(segue:UIStoryboardSegue) {
        // Survey has been completed
        print("Submitted")
    }
    
    
    override func viewDidLoad() {
        
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
        
        createSurveyDocument()
        
        super.viewDidLoad()
    }
    
    func createSurveyDocument(){
        
        let manager = CBLManager.sharedInstance()
        var database: CBLDatabase!
 
        do {
            try database = manager.databaseNamed("survey")
        } catch {
            print("Can't access database")
        }
                
        // retrieve JSON representing a survey
        let api_url = "http://dlib-rainbow.edina.ac.uk:3000/api/survey/566ed9b30351d817555158cd"
        
        Alamofire.request(.GET, api_url)
            .responseJSON { response in
                if let json = response.result.value {
//                    print("JSON: \(json)")
                    
                    let doc = database.createDocument()
                    let docId = doc.documentID
                    
                    do{
                        try doc.putProperties(json as! [String : AnyObject])
                        print("Saved document id ", docId)
                    }catch{
                        print("error adding document")
                    }
                    
                    self.survey = Mapper<Survey>().map(json)
//                    print("\n \(self.survey!.description)")
                }
        }
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
