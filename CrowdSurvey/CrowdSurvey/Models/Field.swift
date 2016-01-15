//
//  Field.swift
//  CrowdSurvey
//
//  Created by Ian Fieldhouse on 14/01/2016.
//  Copyright © 2016 Edina. All rights reserved.
//

import Foundation
import ObjectMapper

class Field: Mappable {
    
    var id: Int?
    var type: String?
    var label: String?
    var properties: [String: AnyObject]?
    var required: Bool?
    var persistent: Bool?
    
    var description: String {
        get {
            return Mapper().toJSONString(self, prettyPrint: false)!
        }
    }
    
    // MARK: - ObjectMapper
    
    required init?(_ map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        id         <- map["id"]
        type       <- map["type"]
        label      <- map["label"]
        required   <- map["required"]
        persistent <- map["persistent"]
        properties <- map["properties"]
    }
}