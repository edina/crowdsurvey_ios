//
//  Field.swift
//  CrowdSurvey
//
//  Created by Ian Fieldhouse on 14/01/2016.
//  Copyright © 2016 Edina. All rights reserved.
//

import Foundation

class Field {
    
    var id: Int
    var type: String
    var label: String
    var required: Bool
    var persistent: Bool
    
    init(id: Int, type: String, label: String, required: Bool, persistent: Bool){
        self.id = id
        self.label = label
        self.type = type
        self.required = required
        self.persistent = persistent
    }
}