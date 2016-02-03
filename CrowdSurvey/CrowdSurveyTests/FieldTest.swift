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
    
            let form = Form()
            
            // Have to set the form on the SurveyViewController otherwise update and other form element
            // callbacks will not be called
            let formVC = SurveyViewController()

            formVC.form  = form
            
            // Check this is a textField
            XCTAssertEqual(textField.type, Constants.Form.TextType)
            
            textField.addTextToForm(form)
            
            // 2 elements - label and textRow
            XCTAssertEqual(form.values(includeHidden: true).count, 2)
            
            // Check label has right title
            XCTAssertEqual(form.rowByTag(Constants.Form.Question1Label)?.title, Constants.Form.Question1Label)
            
            // Get the textRow
            let textRow = form.rowByTag(Constants.Form.Question1TextRowTag) as! TextRow
            
            // Check if row is required - should have a red background if so
            XCTAssertEqual(textField.required, true)

            XCTAssertEqual(textRow.cell.backgroundColor, Constants.Form.requiredRedColour)
            
            // Add a value to the TextRow
            form.setValues([Constants.Form.Question1TextRowTag: Constants.Form.TestTextFormValue])
            
            // Check textField model now has the same value
            XCTAssertEqual(textField.value! as? String, Constants.Form.TestTextFormValue)
            
            // Now a value has been supplied, background colour should be green
            XCTAssertEqual(textRow.cell.backgroundColor, Constants.Form.validGreenColour)
            
            // Check value added to form as expected
            XCTAssertEqual(textRow.value!, Constants.Form.TestTextFormValue)
     
            // Setup mockNotificationCentre so we can be sure a notification was sent
            let mockNotification = MockNSNotificationCenter()
            textField.notificationCentre = mockNotification
        
            // Ensure notification is posted
            textRow.unhighlightCell()

            XCTAssertEqual(mockNotification.postCount, 1, "a notification should have been posted")
  
        }
        
     
    }

}
