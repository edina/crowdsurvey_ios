//
//  Field.swift
//  CrowdSurvey
//
//  Created by Ian Fieldhouse on 14/01/2016.
//  Copyright © 2016 Edina. All rights reserved.
//

import Foundation
import ObjectMapper
import Eureka
import Haneke

class Field: Mappable {
    
    var id: String?
    var label: String?
    var type: String?
    var properties: [String: AnyObject]?
    var required: Bool?
    var persistent: Bool?
    
    
    var containsValue: Bool? {
        var empty = true
        
        if self.value == nil {
            empty = false
        }
        return empty
    }
    
    var containsValidValue: Bool? {
        var valid = true
        
        if let required = self.required {
            
            if required{
                print("required - now check if a value has been added")
                if self.value == nil{
                    valid =  false
                }else{
                   valid =  true
                }
            }
        }
        // Not required will be true
        return valid
    }
    
    // Lazily instantiate the notificationCenter so we can inject the mockNotificationCentre for testing
    lazy var notificationCentre = {
        return NSNotificationCenter.defaultCenter()
    }()
    
    var value: AnyObject?{
        // String or [String]
        didSet {
            //            print("value has changed")
            // save in couchdb - send notification to survey controller
            //            NSNotificationCenter.defaultCenter().postNotificationName(Constants.Notifications.FieldUpdatedNotification, object: nil)
        }
    }
    
    // MARK: - ObjectMapper
    
    required init?(_ map: Map) {
        
    }
    
    init(id: String?, label: String?, value: AnyObject?, type: String?, required: Bool?, persistent: Bool?, properties: [String: AnyObject]?) {
        self.id = id
        self.label = label
        self.value = value
        self.type = type
        self.required = required
        self.persistent = persistent
        self.properties = properties
    }
    
    // Mappable
    func mapping(map: Map) {
        id         <- map["id"]
        label      <- map["label"]
        value      <- map["value"]
        type       <- map["type"]
        required   <- map["required"]
        persistent <- map["persistent"]
        properties <- map["properties"]
    }
    
    var description: String {
        get {
            return Mapper().toJSONString(self, prettyPrint: true)!
        }
    }
}