//
//  RecordField.swift
//  CrowdSurvey
//
//  Created by Ian Fieldhouse on 08/03/2016.
//  Copyright © 2016 Edina. All rights reserved.
//

import Foundation
import ObjectMapper
import Eureka
import Haneke

class RecordField: Field {
    
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
    func addTextToForm(form: Form){
        //         form +++= Section(label!)
        var form = form
        form +++= LabelRow () {
            $0.title = label!
            $0.tag = label!
            $0.value = ""
            $0.cell.textLabel?.numberOfLines=0
            }
            
            // Create text field
            <<< TextRow () {
                $0.title = ""
                $0.tag = label!+"_tag"
                $0.placeholder = "Enter answer…"
                if let value = self.value {
                    $0.value = "\(value)"
                } else {
                    $0.value = ""
                }
                
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
    
    func addRadioToForm(form: Form){
        //        form +++= Section(label!)
        
        var form = form
        form +++= LabelRow () {
            $0.title = label!
            $0.tag = label!
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
    
    func addCheckBoxToForm(form: Form){
        //        form +++= Section(label!)
        
        var form = form
        form +++= LabelRow () {
            $0.title = label!
            $0.tag = label!
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
    
    func addImageToForm(form: Form){
        ImageRow.defaultCellUpdate = { cell, row in
            cell.accessoryView?.layer.cornerRadius = 17
            cell.accessoryView?.frame = CGRectMake(0, 0, 34, 34)
        }
        var form = form
        form +++= LabelRow () {
            $0.title = label!
            $0.tag = label!
            $0.value = ""
            $0.cell.textLabel?.numberOfLines=0
            }
            <<< ImageRow() {
                $0.title = "Choose Photo…"
                $0.tag = label! + "_imageTag"
                if let name = self.value, image = imageFromCache(name as! String) {
                    $0.value = image
                    $0.updateCell()
                }}.onChange({[weak self] row -> () in
                    // Get image, save in documents and add url to model
                    self?.saveImage(row)
                    
                    // Bug requires us to do this if displaying in modal - image won't appear otherwise
                    row.updateCell()
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
    
    func imageFromCache(named: String) -> UIImage? {
        var image: UIImage?
        let cache = Shared.imageCache
        cache.fetch(key: named).onSuccess { fetchedImage in
            image = fetchedImage
        }
        return image
    }
}