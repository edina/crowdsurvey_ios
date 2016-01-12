//
//  MapViewController.swift
//  CrowdSurvey
//
//  Created by Colin Gormley on 11/01/2016.
//  Copyright © 2016 Edina. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    
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
        super.viewDidLoad()
    }

    
    
    
    // MARK: - MKMapViewDelegate
    
    
    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
