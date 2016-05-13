//
//  MapViewController.swift
//  DFS
//
//  Created by Colin Gormley on 12/05/2016.
//  Copyright © 2016 Edina. All rights reserved.
//

import UIKit
import CoreLocation
import LiquidFloatingActionButton
import Mapbox


class MapViewController: UIViewController, CLLocationManagerDelegate, LiquidFloatingActionButtonDataSource, LiquidFloatingActionButtonDelegate, MGLMapViewDelegate, UIGestureRecognizerDelegate {

    // MARK: Variables
    let locationManager = CLLocationManager()
    
    var cells: [LiquidFloatingCell] = []
    var floatingActionButton: LiquidFloatingActionButton!
    
    // MARK: - OUTLETS
    
    // MARK: Variables
    @IBOutlet weak var mapView: MGLMapView!
    @IBOutlet var mapViewPanGesture: UIPanGestureRecognizer!
    @IBOutlet weak var userLocationButton: UIBarButtonItem!
    
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
        self.setupLiquidFloatingActionButton()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // MARK: - SETUP
    
    func setupLiquidFloatingActionButton(){
        
        let createButton: (CGRect, LiquidFloatingActionButtonAnimateStyle) -> LiquidFloatingActionButton = { (frame, style) in
            let floatingActionButton = LiquidFloatingActionButton(frame: frame)
            floatingActionButton.animateStyle = style
            floatingActionButton.dataSource = self
            floatingActionButton.delegate = self
            return floatingActionButton
        }
        
        let cellFactory: (String) -> CustomLiquidFloatingCell = { (iconName) in
            let cell = CustomLiquidFloatingCell(icon: UIImage(named: iconName)!)
            
            cell.type =  Type(rawValue: iconName)!

            return cell
        }
        
        cells.append(cellFactory(Constants.Image.camera))
        cells.append(cellFactory(Constants.Image.gallery))
        
        let floatingFrame = CGRect(x: self.view.frame.width - 56 - 16, y: self.view.frame.height - 56 - 16, width: 56, height: 56)
        let bottomRightButton = createButton(floatingFrame, .Up)
        
        let image = UIImage(named: "Plus")
        bottomRightButton.image = image
 
        self.view.addSubview(bottomRightButton)
    }
    
    func numberOfCells(liquidFloatingActionButton: LiquidFloatingActionButton) -> Int {
        return cells.count
    }
    
    func cellForIndex(index: Int) -> LiquidFloatingCell {
        return cells[index]
    }
    
    func liquidFloatingActionButton(liquidFloatingActionButton: LiquidFloatingActionButton, didSelectItemAtIndex index: Int) {
        let cell = cells[index] as? CustomLiquidFloatingCell
            
        if let type = cell?.type{
            switch type {
            case .Camera:
                print("Launch Camera")
            case Type.Gallery:
                print("Launch Gallery")
            }
        }
        
        liquidFloatingActionButton.close()
    }
    
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

// Use custom cell so we can easily determine what button has been pressed
public class CustomLiquidFloatingCell: LiquidFloatingCell {
    
    public var type : Type = .Camera

    enum StringEnum: String
    {
        case one = "one"
        case two = "two"
        case three = "three"
    }

}

public enum Type : String{
    case Camera = "Camera"
    case Gallery = "Gallery"
}
