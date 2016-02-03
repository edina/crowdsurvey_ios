//
//  FieldTest.swift
//  CrowdSurvey
//
//  Created by Ian Fieldhouse on 20/01/2016.
//  Copyright © 2016 Edina. All rights reserved.
//

import XCTest

import Alamofire
import ObjectMapper
import SwiftyJSON
import Eureka
import Haneke

@testable import CrowdSurvey

class FieldTest: CrowdSurveyTests {
    
    var field: Field!
    
    // Expected field values
    let required = true
    let persistent = true
    
    override func setUp() {
        super.setUp()
        
        if let field = self.survey!.fields?[3] {
            self.field = field
        }
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCreateFieldFromJson() {
       
            XCTAssert(field.id == Constants.Form.Question3Id)
            XCTAssert(field.label == Constants.Form.Question3Label)
            XCTAssert(field.type == Constants.Form.Question3Type)
            XCTAssert(field.required == self.required)
            XCTAssert(field.persistent == self.persistent)
        
    }
    
    func testFieldDescriptionJson() {
        if let jsonData = self.field.description.dataUsingEncoding(NSUTF8StringEncoding) {
            let json = JSON(data: jsonData)
            
            XCTAssert(json["id"].string == Constants.Form.Question3Id)
            XCTAssert(json["label"].string == Constants.Form.Question3Label)
            XCTAssert(json["type"].string == Constants.Form.Question3Type)
            XCTAssert(json["required"].bool == self.required)
            XCTAssert(json["persistent"].bool == self.persistent)
        }
    }
    
    func testAddTextToForm(){
        
        // First field is a text field
        if let textField = self.survey!.fields?[0] {
    
            var form = Form()
            
            // Have to set the form on the SurveyViewController otherwise update and other form element
            // callbacks will not be called
            let formVC = SurveyViewController()

            formVC.form  = form
            
            // Check this is a textField
            XCTAssertEqual(textField.type, Constants.Form.TextType, "Form type us not text as expected")
            
            textField.addTextToForm(form)
            
            // 2 elements - label and textRow
            XCTAssertEqual(form.values(includeHidden: true).count, 2, "2 form elements not found")
            
            // Check label has right title
            XCTAssertEqual(form.rowByTag(Constants.Form.Question1Label)?.title, Constants.Form.Question1Label, "Form label title not as expected")
            
            // Get the textRow
            var textRow = form.rowByTag(Constants.Form.Question1TextRowTag) as! TextRow
            
            // Check if row is required - should have a red background if so
            XCTAssertEqual(textField.required, true, "Expected required")

            XCTAssertEqual(textRow.cell.backgroundColor, Constants.Form.requiredRedColour, "Background for a required field should have been red")
            
            // Add a value to the TextRow
            form.setValues([Constants.Form.Question1TextRowTag: Constants.Form.TestTextFormValue])
            
            // Check textField model now has the same value
            XCTAssertEqual(textField.value! as? String, Constants.Form.TestTextFormValue, "Field value has not been updated")
            
            // Now a value has been supplied, background colour should be green
            XCTAssertEqual(textRow.cell.backgroundColor, Constants.Form.validGreenColour, "Background colour should be green now value has been supplied")
            
            // Check value added to form as expected
            XCTAssertEqual(textRow.value!, Constants.Form.TestTextFormValue, "Value not added to form as expected")
     
            // Setup mockNotificationCentre so we can be sure a notification was sent
            let mockNotification = MockNSNotificationCenter()
            textField.notificationCentre = mockNotification
        
            // Ensure notification is posted
            textRow.unhighlightCell()

            XCTAssertEqual(mockNotification.postCount, 1, "a notification should have been posted")
  
            
            
            // Check behavior with required = false is consistent
            form = Form()
          
            textField.required = false
            textField.addTextToForm(form)
            // Get the textRow
            textRow = form.rowByTag(Constants.Form.Question1TextRowTag) as! TextRow
           
            XCTAssertEqual(textRow.cell.backgroundColor, nil, "Background for a field that is not required should be nil")
            textRow.unhighlightCell()
            
            form.setValues([Constants.Form.Question1TextRowTag: Constants.Form.TestTextFormValue])
            
            XCTAssertEqual(textRow.cell.backgroundColor, nil, "Background colour should be green now value has been supplied")
  
        }
    }
    
    func testAddImageToForm(){
        
        // Second field is an image field
        if let imageField = self.survey!.fields?[1] {
            
            let form = Form()
            
            // Have to set the form on the SurveyViewController otherwise update and other form element
            // callbacks will not be called
            let formVC = SurveyViewController()
            
            formVC.form  = form
            
            // Check this is a textField
            XCTAssertEqual(imageField.type, Constants.Form.ImageType, "Form type us not image as expected")
            
            imageField.addImageToForm(form)
            
            // 2 elements - label and textRow
            XCTAssertEqual(form.values(includeHidden: true).count, 2, "2 form elements not found")
        
            // Check label has right title
            XCTAssertEqual(form.rowByTag(Constants.Form.ImageQuestionLabel)?.title, Constants.Form.ImageQuestionLabel, "Form label title not as expected")

            // Get the ImageRow
            var imageRow = form.rowByTag(Constants.Form.ImageQuestionImageRowTag) as! ImageRow
           
            // Check if row is required - should have a red background if so
            XCTAssertEqual(imageField.required, true, "Expected required")
            
            XCTAssertEqual(imageRow.cell.backgroundColor, Constants.Form.requiredRedColour, "Background for a required field should have been red")

            
            let redImage = UIImage(color: UIColor.redColor())
            
            // Add a value to the TextRow
            form.setValues([Constants.Form.ImageQuestionImageRowTag: redImage])
            
            // Now a value has been supplied, background colour should be green
//            XCTAssertEqual(imageRow.cell.backgroundColor, Constants.Form.validGreenColour, "Background colour should be green now value has been supplied")
       
        }

    }
    
    

}


public extension UIImage {
    convenience init(color: UIColor, size: CGSize = CGSizeMake(50, 50)) {
        let rect = CGRectMake(0, 0, size.width, size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(CGImage: image.CGImage!)
    }  
}