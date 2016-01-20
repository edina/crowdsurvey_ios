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

@testable import CrowdSurvey

class FieldTest: XCTestCase {
    
    var field: Field?
    
    // Expected field values
    let id = "form-radio-2"
    let label = "3. Are you involved in working with trees or forestry?"
    let type = "radio"
    let required = true
    let persistent = true
    
    override func setUp() {
        super.setUp()
        
        var surveyJson: AnyObject?
        let surveyUrl = "http://dlib-rainbow.edina.ac.uk:3000/api/survey/566ed9b30351d817555158cd"
        
        let surveyExpectation = expectationWithDescription("Alamofire Survey Request")
        
        Alamofire.request(.GET, surveyUrl)
            .responseJSON { response in
                if let json = response.result.value {
                    surveyJson = json
                    surveyExpectation.fulfill()
                }
        }
        
        waitForExpectationsWithTimeout(5.0, handler: nil)
        
        if let survey = Mapper<Survey>().map(surveyJson) {
            if let field = survey.fields?[3] {
                self.field = field
            }
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCreateFieldFromJson() {
        if let field = self.field {
            XCTAssert(field.id == self.id)
            XCTAssert(field.label == self.label)
            XCTAssert(field.type == self.type)
            XCTAssert(field.required == self.required)
            XCTAssert(field.persistent == self.persistent)
        }
    }
    
    func testFieldDescriptionJson() {
        if let jsonData = self.field!.description.dataUsingEncoding(NSUTF8StringEncoding) {
            let json = JSON(data: jsonData)
            
            XCTAssert(json["id"].string == self.id)
            XCTAssert(json["label"].string == self.label)
            XCTAssert(json["type"].string == self.type)
            XCTAssert(json["required"].bool == self.required)
            XCTAssert(json["persistent"].bool == self.persistent)
        }
    }
    
}
