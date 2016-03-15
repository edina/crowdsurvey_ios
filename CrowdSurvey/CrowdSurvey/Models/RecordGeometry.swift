//
//  RecordGeometry.swift
//  CrowdSurvey
//
//  Created by Ian Fieldhouse on 14/03/2016.
//  Copyright © 2016 Edina. All rights reserved.
//

import Foundation
import CoreLocation
import Mapbox
import ObjectMapper

class RecordGeometry: NSObject, Mappable, MGLAnnotation {
    
    var coordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0) // set to 0.0,0.0 as MGLAnnotation requires this to not be optional
    var type = "Point"
    
    var title: String?
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
    
    // MARK: - ObjectMapper
    
    required init?(_ map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        coordinate <- (map["coordinate"], CoordinateTransform())
        type       <- map["type"]
    }
}