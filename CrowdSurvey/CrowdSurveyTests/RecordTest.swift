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

@testable import CrowdSurvey


class RecordTest: XCTestCase {
    
    var survey: Survey?
    var recordFromJson: Record?
    var recordFromSurvey: Record?
    
    override func setUp() {
        super.setUp()
        
        var surveyJson: AnyObject?
        let surveyUrl = "http://dlib-rainbow.edina.ac.uk:3000/api/survey/566ed9b30351d817555158cd"
        
        var recordJson: AnyObject?
        let recordUrl = "http://dlib-rainbow.edina.ac.uk:3000/api/records/566ed9290351d817555158cc"
        
        let surveyExpectation = expectationWithDescription("Alamofire Survey Request")
        
        Alamofire.request(.GET, surveyUrl)
            .responseJSON { response in
                if let json = response.result.value {
                    surveyJson = json
                    surveyExpectation.fulfill()
                }
        }
        
        let recordExpectation = expectationWithDescription("Alamofire Record Request")
        
        Alamofire.request(.GET, recordUrl)
            .responseJSON { response in
                if let json = response.result.value {
                    recordJson = json
                    recordExpectation.fulfill()
                }
        }
        
        waitForExpectationsWithTimeout(5.0, handler: nil)
        
        self.survey = Mapper<Survey>().map(surveyJson)
        self.recordFromJson = Mapper<Record>().map(recordJson)
        self.recordFromSurvey = Record(survey: self.survey!)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCreateRecordFromJson() {
        let id = "566ed9290351d817555158cc"
        let name = "record (03-11-2015 12h11m44s)"
        let type = "Feature"
        let editor = "5106d3aa-99ac-4186-b50d-6fcfdf9946f4.edtr"
        
        XCTAssert(self.recordFromJson!.id == id)
        XCTAssert(self.recordFromJson!.name == name)
        XCTAssert(self.recordFromJson!.type == type)
        XCTAssert(self.recordFromJson!.editor == editor)
    }
        
    }
}
