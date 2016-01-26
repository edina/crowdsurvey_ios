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
    var value: AnyObject? // String or [String]
    var type: String?
    var properties: [String: AnyObject]?
    var required: Bool?
    var persistent: Bool?
   
    let requiredRedColour = UIColor(
        red:1,
        green:0.1,
        blue:0.1,
        alpha:0.1)
    
    let validGreenColour = UIColor(
        red:0.1,
        green:1,
        blue:0.1,
        alpha:0.1)
    
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
        static let SelectPlaceHolder = "Select…"
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
                $0.placeholder = "Enter answer…"
                }.onChange {[weak self] row in
     
                    if let value = row.value{
                        print(value)
                        self?.value = value
                        
                        // Change cell background to green
                        row.cell!.backgroundColor = self?.validGreenColour
                        
                    }
                    // TODO: Need to work out a way of adding to the record model rather than survey
                    
                } .onCellUnHighlight { [weak self] cell, row  in
                    
                    // Note that for onCellUnHighlight to be called we have to also implement onCellHighlight below
                    if row.value == nil{
                        if self?.required?.boolValue ?? false{
                            row.cell!.backgroundColor = self?.requiredRedColour
                        }
                    }

                }.onCellHighlight { cell, row in
                    //Has to be implemented so above gets called
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
                        $0.value = Constants.SelectPlaceHolder
                        $0.selectorTitle = ""
                    }.onChange { [weak self] row in
                        
                        if let value = row.value{
                            print(value)
                            self?.value = value
                        }
                            
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
                        $0.value = [Constants.SelectPlaceHolder]
                        }.onChange { [weak self] row in
                            
                            
                            if let value = row.value{
                                print(value)
                                // Ensure that the 'Select…' placeholder is removed
                                row.value?.remove(Constants.SelectPlaceHolder)
                                
                                self?.value = value
                            }
          
                            // TODO: Need to work out a way of adding to the record model rather than survey
                }
            }else{
                // TODO: Dictionary
                
            }
        }
    }
    
    func addImageToForm(var form: Form){
        ImageRow.defaultCellUpdate = { cell, row in
            cell.accessoryView?.layer.cornerRadius = 17
            cell.accessoryView?.frame = CGRectMake(0, 0, 34, 34)
        }
        form +++= LabelRow () {
            $0.title = label!
            $0.value = ""
            $0.cell.textLabel?.numberOfLines=0
            }
            <<< ImageRow() {
                $0.title = "Choose Photo…"
                }.onChange({[weak self] row -> () in
                    // Get image, save in documents and add url to model
                    self?.saveImage(row)
                    
                })
    }
    
    
    func saveImage(row: ImageRow ){
 
        if let image = row.value{
            
            let cache = Shared.imageCache
            
            let now = round(NSDate().timeIntervalSince1970) // seconds
            
            let url = "\(now).jpg"
            
            cache.set(value: image, key: url, success: {image in self.value = url})
        
        }
        
    }
    
    
    
    
}