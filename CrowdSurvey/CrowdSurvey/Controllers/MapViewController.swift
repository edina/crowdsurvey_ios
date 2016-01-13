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

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    
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
        
        mapView.showsUserLocation = true
        
        
//        var manager = CBLManager.sharedInstance()
//        var database: CBLDatabase?
//        
//        // Using try! indicates we don't expect a failure
//        try! database = manager.databaseNamed("crowdsurvey")
//        
//        // retrieve JSON representing a survey
//        // most up to date gist to be found at https://gist.github.com/rgamez/accb2404e7f5ebad105c
//        let api_url = "https://gist.github.com/rgamez/accb2404e7f5ebad105c/raw/b309f8455a80842c24d84f087319ba363d1c4cc9/survey-proposal-arrrays-everywhere.json"
//        
//        Alamofire.request(.GET, api_url)
//            .responseJSON { response in
//                print(response.request)  // original URL request
//                print(response.response) // URL response
//                print(response.data)     // server data
//                print(response.result)   // result of response serialization
//                
//                if let JSON = response.result.value {
//                    print("JSON: \(JSON)")
//                }
//        }

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
        // most up to date gist to be found at https://gist.github.com/rgamez/accb2404e7f5ebad105c
        let api_url = "https://gist.github.com/rgamez/accb2404e7f5ebad105c/raw/b309f8455a80842c24d84f087319ba363d1c4cc9/survey-proposal-arrrays-everywhere.json"
        
        Alamofire.request(.GET, api_url)
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    
                    let doc = database.createDocument()
                    let docId = doc.documentID
                    
                    do{
                        try doc.putProperties(JSON as! [String : AnyObject])
                        
                        print("Saved document id ", docId)
                    }catch{
                        print("error adding document")
                    }
                }
                
                

                
        }
        
        // Try reading it back
        //        let d = database.documentWithID(docId)
        //
        //        for (prop in d?.properties){
        //
        //        }
        //        let name = d["name"]
        //        print(name)
    }
    
    
    // MARK: - MKMapViewDelegate
    
    // MARK: - CLLocationManager
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.mapView.setRegion(region, animated: true)
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
