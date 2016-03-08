//
//  Survey.swift
//  CrowdSurvey
//
//  Created by Ian Fieldhouse on 14/01/2016.
//  Copyright © 2016 Edina. All rights reserved.
//

import Foundation
import CoreLocation
import ObjectMapper
import Eureka	
import SwiftyJSON

class Survey: Mappable, CustomStringConvertible {
    
    var id: String?
    var title: String?
    var geoms: [String]?
    var fields: [Field]?
    var layout: [String: AnyObject]?
    var records: [Record]? = []
    var location: CLLocation? // used to store user's selected location from MapView
    
    
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
            let locationField = Field(id: Constants.Form.Location, value: locationValue)
            locationField.label = Constants.Form.Location.capitalizedString
            locationField.type = Constants.Form.Text
            locationField.required = true
            locationField.appendToForm(form)
        }
        
        for Field in fields!{
            //print(Field.description)
            
            // Get appropriate form element for this Field
            Field.appendToForm(form)
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