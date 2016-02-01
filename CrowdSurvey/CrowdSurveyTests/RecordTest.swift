//
//  RecordTest.swift
//  CrowdSurvey
//
//  Created by Ian Fieldhouse on 19/01/2016.
//  Copyright © 2016 Edina. All rights reserved.
//

import XCTest

import Alamofire
import ObjectMapper
import SwiftyJSON

@testable import CrowdSurvey


class RecordTest: CrowdSurveyTests {
    
    var recordFromJson: Record?
    var recordFromSurvey: Record?
    
    override func setUp() {
        super.setUp()
 
        var recordJson: AnyObject?
        let recordUrl = "http://dlib-rainbow.edina.ac.uk:3000/api/records/566ed9290351d817555158cc"
        
        let recordExpectation = expectationWithDescription("Alamofire Record Request")
        
        Alamofire.request(.GET, recordUrl)
            .responseJSON { response in
                if let json = response.result.value {
                    recordJson = json
                    recordExpectation.fulfill()
                }
        }
        
        waitForExpectationsWithTimeout(5.0, handler: nil)

        self.recordFromJson = Mapper<Record>().map(recordJson)
        self.recordFromSurvey = Record(survey: self.survey!)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCreateRecordFromJson() {
     
        let name = "record (03-11-2015 12h11m44s)"
        let type = "Feature"
        let editor = "5106d3aa-99ac-4186-b50d-6fcfdf9946f4.edtr"
        
        if let record = self.recordFromJson {
            XCTAssert(record.id == Constants.Record.Id)
            XCTAssert(record.name == name)
            XCTAssert(record.type == type)
            XCTAssert(record.editor == editor)
        }
    }
    
    func testCreateRecordFromSurvey() {
        let id = "SOME_AUTO_GENERATED_ID"
        let name = "SOME_AUTO_GENERATED_NAME"
        let type = "Feature"
        
        if let survey = self.survey {
            let editor = survey.id
            
            if let record = self.recordFromSurvey {
                XCTAssert(record.id == id)
                XCTAssert(record.name == name)
                XCTAssert(record.type == type)
                XCTAssert(record.editor == editor)
            }
        }
    }
    
    func testRecordDescriptionJson() {
        
        let name = "record (03-11-2015 12h11m44s)"
        let type = "Feature"
        let editor = "5106d3aa-99ac-4186-b50d-6fcfdf9946f4.edtr"
        
        if let jsonData = self.recordFromJson!.description.dataUsingEncoding(NSUTF8StringEncoding) {
            let json = JSON(data: jsonData)
            
            XCTAssert(json["id"].stringValue == Constants.Record.Id)
            XCTAssert(json["name"].stringValue == name)
            XCTAssert(json["type"].stringValue == type)
            XCTAssert(json["properties"]["editor"].stringValue == editor)
        }
    }
}
