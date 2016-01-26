//
//  Survey.swift
//  CrowdSurvey
//
//  Created by Ian Fieldhouse on 14/01/2016.
//  Copyright © 2016 Edina. All rights reserved.
//

import Foundation
import ObjectMapper
import Eureka	

class Survey: Mappable, CustomStringConvertible {
    
    var id: String?
    var title: String?
    var geoms: [String]?
    var fields: [Field]?
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
    }
    
    var description: String {
        get {
            return Mapper().toJSONString(self, prettyPrint: true)!
        }
    }
    
    
    // MARK: - Form
    
    // Returns the generated form for this survey
    func form() -> Form!{
        
        var form = Form()
        // Add an empty section initially
        form +++= Section()
        
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
                        print("value exists")
                        print(Field.value!)
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