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
        let form = Form()
        self.field.addTextToForm(form)
        
        XCTAssertEqual(form.values(includeHidden: true).count, 1)

        XCTAssertEqual(form.rowByTag(Constants.Form.Question3Label)?.title, Constants.Form.Question3Label)
    }
    
}
