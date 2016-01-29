//
//  Record.swift
//  CrowdSurvey
//
//  Created by Ian Fieldhouse on 15/01/2016.
//  Copyright © 2016 Edina. All rights reserved.
//

import Foundation
import GeoJSON
import ObjectMapper

class Record: Mappable, CustomStringConvertible {
    
    var id: String?
    var name: String?
    var type = "Feature"
    var geometry: [String: AnyObject]?
    
    // properties
    var editor: String?
    var fields: [Field]?
    var timestamp: NSDate?
    
    
    init(survey: Survey){
        // TODO: create id and name
        self.id = "SOME_AUTO_GENERATED_ID"
        self.name = "SOME_AUTO_GENERATED_NAME"
        self.editor = survey.id

        
        // Create create new field releated to this Record instance
        self.fields = []
        
        for field in survey.fields!{
            self.fields?.append(Field(id: field.id, value: field.value))
        }
        
        self.timestamp = NSDate()
        print("Record created")
    }
    
    
    // MARK: - ObjectMapper
    
    required init?(_ map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        id        <- map["id"]
        name      <- map["name"]
        editor    <- map["properties.editor"]
        fields    <- map["properties.fields"]
        timestamp <- (map["properties.timestamp"], ISO8601DateTransform())
        type      <- map["type"]
    }
    
    var description: String {
        get {
            return Mapper().toJSONString(self, prettyPrint: true)!
        }
    }
}