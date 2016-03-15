//
//  RecordGeometry.swift
//  CrowdSurvey
//
//  Created by Ian Fieldhouse on 14/03/2016.
//  Copyright © 2016 Edina. All rights reserved.
//

import Foundation
import CoreLocation
import ObjectMapper

struct RecordGeometry: Mappable {
    
    var coordinate: CLLocationCoordinate2D?
    var type = "Point"
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
    
    init?(_ map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        coordinate <- (map["coordinate"], CoordinateTransform())
        type       <- map["type"]
    }
}