//
//  Survey.swift
//  CrowdSurvey
//
//  Created by Ian Fieldhouse on 14/01/2016.
//  Copyright © 2016 Edina. All rights reserved.
//

import Foundation

class Survey {
    
    var id: String
    var title: String
    var geoms: Array<String>
    var fields: Array<Field>
    
    init(id: String, title: String, geoms: Array<String>, fields: Array<Field>){
        self.id = id
        self.title = title
        self.geoms = geoms
        self.fields = fields
    }
}