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

class Field: Mappable {
    
    var id: String?
    var label: String?
    var value: AnyObject? // String or [String]
    var type: String?
    var properties: [String: AnyObject]?
    var required: Bool?
    var persistent: Bool?
    
        
    // MARK: - Constants
    
    private struct Constants {
        static let Text = "text"
        static let Checkbox = "checkbox"
        static let Radio = "radio"
        static let Image = "image"
        static let Select = "select"
        static let Dtree = "dtree"
        static let Warning = "warning"
        static let Range = "range"
    }

    
    // MARK: - ObjectMapper
    
    required init?(_ map: Map) {
        
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
    
    
    // MARK: - Form
    
    // Detect which kind of form element to construct
    func appendToForm(form: Form){
        
        switch (type!)
        {
        case Constants.Text:
            print("text field")
            addTextToForm(form)
            
        case Constants.Radio:
            print("radio field")
            addRadioToForm(form)
            
        case Constants.Image:
            
            print("image field")
            addImageToForm(form)
            
        case Constants.Dtree:
            
            print("dtree field")
        case Constants.Warning:
            
            print("warning field")
        case Constants.Select:
            
            print("Select field")
        case Constants.Range:
            
            print("range field")
        case Constants.Checkbox:
            
            print("checkbox field")
            addCheckBoxToForm(form)
            
        default:
            print("default")
        }
    }
    
    // Add a simple text field
    func addTextToForm(var form: Form){
//         form +++= Section(label!)
  
        form +++= LabelRow () {
            $0.title = label!
            $0.value = ""
            $0.cell.textLabel?.numberOfLines=0
        }
        
        // Create text field
          <<< TextRow () {
            $0.title = ""
            $0.placeholder = ""
            }.onChange { row in
                
                print(row.value)
                self.value = row.value!
                
                // TODO: Need to work out a way of adding to the record model rather than survey
            }
    }
    
    func addRadioToForm(var form: Form){
//        form +++= Section(label!)
        
        form +++= LabelRow () {
            $0.title = label!
            $0.value = ""
            $0.cell.textLabel?.numberOfLines=0
        }
        
        if let options = properties!["options"] {
            print("The options are \(options).")

            // Check if simple string array
            if let optionsArray = options as? [String] {
                form.last! <<<
                    
                    PushRow<String>() {
                        $0.title = ""
                        $0.options = optionsArray
                        $0.value = ""
                        $0.selectorTitle = ""
                    }.onChange { row in
                            
                            print(row.value)
                            self.value = row.value!
                            
                            // TODO: Need to work out a way of adding to the record model rather than survey
                    }
            }else{
                // TODO: Dictionary
                
            }
            
        }
    }
    
    
    
    func addCheckBoxToForm(var form: Form){
//        form +++= Section(label!)
        
        form +++= LabelRow () {
            $0.title = label!
            $0.value = ""
            $0.cell.textLabel?.numberOfLines=0
        }
        
        
        if let options = properties!["options"] {
            print("The options are \(options).")
            
            // Check if simple string array
            if let optionsArray = options as? [String] {
                form.last! <<<
                    
                    MultipleSelectorRow<String>() {
                        $0.title = ""
                        $0.options = optionsArray
                        $0.selectorTitle = ""
                        }.onChange { row in
                            
                            print(row.value)
                            self.value = row.value!
                            
                            // TODO: Need to work out a way of adding to the record model rather than survey
                }
            }else{
                // TODO: Dictionary
                
            }
        }
    }
    
    func addImageToForm(var form: Form){

        form +++= LabelRow () {
            $0.title = label!
            $0.value = ""
            $0.cell.textLabel?.numberOfLines=0
        }
        <<< ImageRow() {
            $0.title = ""
            }
    }
    
}