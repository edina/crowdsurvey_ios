//
//  CoordinateTransform.swift
//  CrowdSurvey
//
//  Created by Ian Fieldhouse on 15/03/2016.
//  Copyright © 2016 Edina. All rights reserved.
//

import Foundation
import CoreLocation
import ObjectMapper

public class CoordinateTransform: TransformType {
    public typealias Object = CLLocationCoordinate2D
    public typealias JSON = Array<Double>
    
    public init() {}
    
    public func transformFromJSON(value: AnyObject?) -> CLLocationCoordinate2D? {
        if let coordinateString = value as? [Double?] {
            guard coordinateString.count >= 2 else { return nil }
            guard let latitude = coordinateString[1], longitude = coordinateString[0] else { return nil }
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        return nil
    }
    
    public func transformToJSON(value: CLLocationCoordinate2D?) -> Array<Double>? {
        if let coordinate = value {
            return [coordinate.longitude, coordinate.latitude]
        }
        return nil
    }
}