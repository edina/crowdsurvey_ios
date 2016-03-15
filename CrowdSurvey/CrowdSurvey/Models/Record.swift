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
    var geometry: RecordGeometry?
    
    // properties
    var editor: String?
    var fields: [RecordField]?
    var timestamp: NSDate?
    
    enum RecordState : String {
        case Incomplete = "Incomplete"
        case Complete = "Complete"
        case Submitted = "Submitted"
        case New = "New"
    }
    
    // If set to true, subsequent calls to state will return RecordState.Submitted
    var submitted: Bool?
    
    var state: RecordState?  {
        
        if (self.submitted ?? false){
            // record has been submitted to API
            return RecordState.Submitted
        }
        if (self.areAllFieldsEmpty() ?? false) {
            return RecordState.New
        }
        if (self.doAllFieldsContainValidValues() ?? false) {
            return RecordState.Complete
        }
        
        // Otherwise record is incomplete
        return RecordState.Incomplete
    }
    
    
    init(survey: Survey, geometry: RecordGeometry){
        // TODO: create id and name
        self.id = "SOME_AUTO_GENERATED_ID"
        self.name = "SOME_AUTO_GENERATED_NAME"
        self.editor = survey.id
        self.geometry = geometry

        self.submitted = false
        
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
        submitted  <- map["submitted"]
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
//        if let location = self.location {
//            let locationValue = "\(round(location.coordinate.latitude*10000)/10000), \(round(location.coordinate.longitude*10000)/10000)"
//            let locationField = RecordField(
//                                    id: Constants.Form.Location,
//                                    label: Constants.Form.Location.capitalizedString,
//                                    value: locationValue,
//                                    type: Constants.Form.Text,
//                                    required: true,
//                                    persistent: true,
//                                    properties: [Constants.Form.Location: true]
//                                )
//            locationField.appendToForm(form)
//        }
        
        for field in fields!{
            //print(Field.description)
            
            // Get appropriate form element for this Field
            field.appendToForm(form)
        }
        
        return form
    }
    
    
    func areAllFieldsEmpty() -> Bool? {
        return self.fields?.filter({$0.containsValue!}).isEmpty
    }
    
    func doAllFieldsContainValidValues() -> Bool? {
        return self.fields?.filter({!($0.containsValidValue!)}).isEmpty
    }
 }