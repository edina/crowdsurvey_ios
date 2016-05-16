//
//  MapViewController.swift
//  DFS
//
//  Created by Colin Gormley on 12/05/2016.
//  Copyright © 2016 Edina. All rights reserved.
//

import UIKit
import CoreLocation
import Mapbox


class MapViewController: UIViewController, CLLocationManagerDelegate, MGLMapViewDelegate, UIGestureRecognizerDelegate {

    // MARK: Variables
    let locationManager = CLLocationManager()
    
    // MARK: - OUTLETS
    
    // MARK: Variables
    @IBOutlet weak var mapView: MGLMapView!
    @IBOutlet var mapViewPanGesture: UIPanGestureRecognizer!
    @IBOutlet weak var userLocationButton: UIBarButtonItem!
    
    @IBOutlet weak var addPhoto: UIButton!{
        didSet{
            addPhoto.layer.cornerRadius = 30
            addPhoto.layer.shadowColor = UIColor.blackColor().CGColor
            addPhoto.layer.shadowOffset = CGSizeMake(2, 2)
            addPhoto.layer.shadowRadius = 5
            addPhoto.layer.shadowOpacity = 0.5
            addPhoto.setTitleColor(Constants.Colour.LightBlue, forState: UIControlState.Normal)
        }
    }
    // MARK: Actions
    
    @IBAction func setMapToUserLocation(sender: UIBarButtonItem) {
        // TODO: Check user location is within survey bounding box
        userLocationButton.image = UIImage(named: Constants.Image.LocationArrowIcon)
        mapView.setCenterCoordinate(locationManager.location!.coordinate, animated: true)
    }
    
    @IBAction func mapDrag(sender: UIPanGestureRecognizer) {
        if(sender.state == UIGestureRecognizerState.Changed){
            let locationOutlineImage = UIImage(named: Constants.Image.LocationArrowIconOutline)
            if let image = userLocationButton.image {
                if image != locationOutlineImage{
                    userLocationButton.image = locationOutlineImage
                }
            }
        }
    }
    
    // MARK: - VIEW LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapViewPanGesture.delegate = self
        self.setupMapView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // MARK: - SETUP
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
    }
    
    // MARK: - DELEGATE METHODS
    
    // MARK: UIGestureRecognizerDelegate
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
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