//
//  Survey.swift
//  CrowdSurvey
//
//  Created by Ian Fieldhouse on 14/01/2016.
//  Copyright © 2016 Edina. All rights reserved.
//

import Foundation
import ObjectMapper	

class Survey: Mappable, CustomStringConvertible {
    
    var id: String?
    var title: String?
    var geoms: [String]?
    var fields: [Field]?
    
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
        id     <- map["id"]
        title  <- map["title"]
        fields <- map ["fields"]
    }
    
}