//
//  Survey.swift
//  CrowdSurvey
//
//  Created by Ian Fieldhouse on 14/01/2016.
//  Copyright © 2016 Edina. All rights reserved.
//

import Foundation
import ObjectMapper
import SwiftyJSON

class Survey: Mappable, CustomStringConvertible {
    
    var id: String?
    var title: String?
    var geoms: [String]?
    var fields: [SurveyField]?
    var layout: [String: AnyObject]?
    var records: [Record]? = []
    
    
    // MARK: - ObjectMapper
    
    required init?(_ map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        id     <- map["id"]
        title  <- map["title"]
        fields <- map ["fields"]
        layout <- map ["layout"]
        records <- map ["records"]
    }
    
    var description: String {
        get {
            return Mapper().toJSONString(self, prettyPrint: true)!
        }
    }
    
    // Get json representation of object graph
    func jsonDict() -> [String : AnyObject]  {
        return Mapper().toJSON(self)
    }
}