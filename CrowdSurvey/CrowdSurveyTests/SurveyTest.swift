//
//  SurveyTest.swift
//  CrowdSurvey
//
//  Created by Ian Fieldhouse on 19/01/2016.
//  Copyright © 2016 Edina. All rights reserved.
//

import XCTest

import Alamofire
import ObjectMapper
import SwiftyJSON
import Eureka

@testable import CrowdSurvey

class SurveyTest: CrowdSurveyTests {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCreateSurveyFromJson() {
        
        if let survey = self.survey {
            XCTAssert(survey.id == Constants.Survey.Id)
            XCTAssert(survey.title == Constants.Survey.Title)
        }
    }
    
    func testSurveyDescriptionJson() {
              
        if let jsonData = self.survey!.description.dataUsingEncoding(NSUTF8StringEncoding) {
            let json = JSON(data: jsonData)
            
            XCTAssert(json["id"].stringValue == Constants.Survey.Id)
            XCTAssert(json["title"].stringValue == Constants.Survey.Title)
        }
    }
    
    func testValidateFormEntries(){
        
        // No values added at all so will fail in the first instance
        XCTAssertFalse(self.survey!.validateFormEntries())
        
        // Add test values for all required form fields
        for field in self.survey!.fields!{
            if field.required?.boolValue ?? false{
                field.value = "test required value"
            }
        }
        
        XCTAssertTrue(self.survey!.validateFormEntries())
        
    }
    
    
    func testValidateForm(){
        
        // Check the form is generated correctly
        let form = self.survey!.form()
   
        XCTAssertEqual(form.rowByTag(Constants.Form.TakePhotoLabel)?.title, Constants.Form.TakePhotoLabel)
        XCTAssertEqual(form.rowByTag(Constants.Form.Question1Label)?.title, Constants.Form.Question1Label)
        XCTAssertEqual(form.rowByTag(Constants.Form.Question2Label)?.title, Constants.Form.Question2Label)
        XCTAssertEqual(form.rowByTag(Constants.Form.Question3Label)?.title, Constants.Form.Question3Label)       
        
        XCTAssertEqual(form.count, 18)
    }
}
