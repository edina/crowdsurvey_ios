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
    let notificationCentre = NSNotificationCenter.defaultCenter()
    
    var value: AnyObject?{
        // String or [String]
        didSet {
            //            print("value has changed")
            // save in couchdb - send notification to survey controller
            //            NSNotificationCenter.defaultCenter().postNotificationName(Constants.Notifications.FieldUpdatedNotification, object: nil)
        }
    }
    
    var type: String?
    var properties: [String: AnyObject]?
    var required: Bool?
    var persistent: Bool?

    
    // MARK: - ObjectMapper
    
    required init?(_ map: Map) {
        
    }
    
    init(id: String?, value: AnyObject?) {
        self.id = id
        self.value = value
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
        case Constants.Form.Text:
            print("text field")
            addTextToForm(form)
            
        case Constants.Form.Radio:
            print("radio field")
            addRadioToForm(form)
            
        case Constants.Form.Image:
            
            print("image field")
            addImageToForm(form)
            
        case Constants.Form.Dtree:
            
            print("dtree field")
        case Constants.Form.Warning:
            
            print("warning field")
        case Constants.Form.Select:
            
            print("Select field")
        case Constants.Form.Range:
            
            print("range field")
        case Constants.Form.Checkbox:
            
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
                        row.cell!.backgroundColor = Constants.Form.validGreenColour
                        
                    }
                    
                } .onCellUnHighlight { [weak self] cell, row  in
                    
                    // Notify survey controller that a change has to be save to couchDB
                    self?.notificationCentre.postNotificationName(Constants.Notifications.FieldUpdatedNotification, object: nil)
                    
                    // Note that for onCellUnHighlight to be called we have to also implement onCellHighlight below
                    if row.value == nil{
                        if self?.required?.boolValue ?? false{
                            row.cell!.backgroundColor = Constants.Form.requiredRedColour
                        }
                    }

                }.onCellHighlight { cell, row in
                    //Has to be implemented so above gets called
                }.cellSetup { [weak self] cell, row in
                    if self?.required?.boolValue ?? false{
                        row.cell!.backgroundColor = Constants.Form.requiredRedColour
                    }
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
                        $0.value = Constants.Form.SelectPlaceHolder
                        $0.selectorTitle = ""
                    }.onChange { [weak self] row in
                        
                        if let value = row.value{
                            print(value)
                            
                            if(value == Constants.Form.SelectPlaceHolder){
                                // required
                                if self?.required?.boolValue ?? false{
                                    row.cell!.backgroundColor = Constants.Form.requiredRedColour
                                }
                            }else{
                                self?.value = value
                                
                                // Update CouchDb
                                self?.notificationCentre.postNotificationName(Constants.Notifications.FieldUpdatedNotification, object: nil)
                                
                                // Change cell background to green
                                row.cell!.backgroundColor = Constants.Form.validGreenColour
                            }
                            
                            
                        }else{
                            // Only highlight if required
                            if self?.required?.boolValue ?? false{
                                row.cell!.backgroundColor = Constants.Form.requiredRedColour
                            }else{
                                row.cell!.backgroundColor = .whiteColor()
                            }
                            row.value = Constants.Form.SelectPlaceHolder
                        }
                        }.cellSetup { [weak self] cell, row in
                            if self?.required?.boolValue ?? false{
                                row.cell!.backgroundColor = Constants.Form.requiredRedColour
                            }
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
                        $0.value = [Constants.Form.SelectPlaceHolder]
                        }.onChange { [weak self] row in
                            
                            
                            if let value = row.value{
                              
                                print(value)
                                // Ensure that the 'Select…' placeholder is removed
                                row.value?.remove(Constants.Form.SelectPlaceHolder)
                                
                                self?.value = value
                                
                                // Update CouchDb
                                self?.notificationCentre.postNotificationName(Constants.Notifications.FieldUpdatedNotification, object: nil)
                                
                                if value.count == 0{
                                    row.cell!.backgroundColor = .whiteColor()
                                    if self?.required?.boolValue ?? false{
                                        row.cell!.backgroundColor = Constants.Form.requiredRedColour
                                    }
                                }else{
                                    // Change cell background to green
                                    row.cell!.backgroundColor = Constants.Form.validGreenColour
                                }
                                
                            }
                        }.cellSetup { [weak self] cell, row in
                            if self?.required?.boolValue ?? false{
                                row.cell!.backgroundColor = Constants.Form.requiredRedColour
                            }
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
                    
                    }).cellSetup { [weak self] cell, row in
                        if self?.required?.boolValue ?? false{
                            row.cell!.backgroundColor = Constants.Form.requiredRedColour
                        }
        }
        
    }
    
    
    func saveImage(row: ImageRow ){
 
        if let image = row.value{
            
            let cache = Shared.imageCache
            
            let now = round(NSDate().timeIntervalSince1970) // seconds
            
            let url = "\(now).jpg"
            
            cache.set(value: image, key: url, success: {image in
                self.value = url
                
                // Update CouchDb
                self.notificationCentre.postNotificationName(Constants.Notifications.FieldUpdatedNotification, object: nil)
                
                row.cell!.backgroundColor = Constants.Form.validGreenColour
            })
        
        }
        
    }
    
    
    
    
}