//
//  Record.swift
//  CrowdSurvey
//
//  Created by Ian Fieldhouse on 15/01/2016.
//  Copyright © 2016 Edina. All rights reserved.
//



import CoreLocation
import Eureka
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
    var fields: [RecordField]?
    var timestamp: NSDate?
    
    var location: CLLocation? // used to store user's selected location from MapView
    
    
    init(survey: Survey, location: CLLocation){
        // TODO: create id and name
        self.id = "SOME_AUTO_GENERATED_ID"
        self.name = "SOME_AUTO_GENERATED_NAME"
        self.editor = survey.id

        // Create create new field releated to this Record instance
        self.fields = []
        
        for field in survey.fields!{
            self.fields?.append(
                RecordField(
                    id: field.id,
                    label: field.label,
                    value: field.value,
                    type: field.type,
                    required: field.required,
                    persistent: field.persistent,
                    properties: field.properties
                )
            )
        }
        self.location = location
        self.geometry = [
                "coordinates": [location.coordinate.longitude, location.coordinate.latitude],
                "type": "Point"
        ]
        
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
        geometry  <- map["geometry"]
    }
    
    var description: String {
        get {
            return Mapper().toJSONString(self, prettyPrint: true)!
        }
    }
    
    // MARK: - Form
    
    // Returns the generated form for this survey
    func form() -> Form!{
        
        // TODO Currently Fields can be create from a Survey and then rendered as form
        // elements or created as part of a Record to store a users response. This should
        // be changed so that Fields are only created as part of a Record and should
        // encapsulate all the necessary information required to display a Form element
        // and any user's response. A Record (either new  or existing) can then be used
        // as the building block for rendering a Form, i.e. this form() method would be
        // moved into Record.swift and refactored to work as above.
        
        let form = Form()
        
        // Add location form element
        if let location = self.location {
            let locationValue = "\(round(location.coordinate.latitude*10000)/10000), \(round(location.coordinate.longitude*10000)/10000)"
            let locationField = RecordField(
                                    id: Constants.Form.Location,
                                    label: Constants.Form.Location.capitalizedString,
                                    value: locationValue,
                                    type: Constants.Form.Text,
                                    required: true,
                                    persistent: true,
                                    properties: [Constants.Form.Location: true]
                                )
            locationField.appendToForm(form)
        }
        
        for field in fields!{
            //print(Field.description)
            
            // Get appropriate form element for this Field
            field.appendToForm(form)
        }
        
        return form
    }
    
    // Check all required Fields have been submitted
    func validateFormEntries() -> Bool{
        
        var valid = true
        
        if let fields = self.fields {
            for Field in fields{
                
                // Check required field has been completed
                if Field.required?.boolValue ?? false{
                    print("required")
                    
                    if let value = Field.value{
                        print(value)
                    }else{
                        valid = false
                        break
                    }
                    
                    
                }
            }
        }
        return valid
    }
}