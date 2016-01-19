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
    
    var recordJson: AnyObject?
    let url = "http://dlib-rainbow.edina.ac.uk:3000/api/records/566ed9290351d817555158cc"
    
    
    
    override func setUp() {
        super.setUp()
        
        let expectation = expectationWithDescription("Alamofire")
        
        Alamofire.request(.GET, self.url)
            .responseJSON { response in
                if let json = response.result.value {
                    self.recordJson = json
                    expectation.fulfill()
                }
        }
        waitForExpectationsWithTimeout(5.0, handler: nil)
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
        
        let record = Mapper<Record>().map(self.recordJson)
        
        XCTAssert(record!.id == id)
        XCTAssert(record!.name == name)
        XCTAssert(record!.type == type)
        XCTAssert(record!.editor == editor)
        
    }
}
