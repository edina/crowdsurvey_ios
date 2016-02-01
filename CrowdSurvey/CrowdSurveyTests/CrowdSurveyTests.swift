//
//  CrowdSurveyTests.swift
//  CrowdSurveyTests
//
//  Created by Colin Gormley on 11/01/2016.
//  Copyright © 2016 Edina. All rights reserved.
//

import XCTest
import Alamofire
import ObjectMapper
import SwiftyJSON
@testable import CrowdSurvey

class CrowdSurveyTests: XCTestCase {
    
    var survey: Survey?
    
    // Test Constants
    struct Constants {
        struct Survey {
            static let Id = "566ed9b30351d817555158cd"
            static let Url = "http://dlib-rainbow.edina.ac.uk:3000/api/survey/566ed9b30351d817555158cd"
            static let Title = "OPAL Tree Health"
        }
        struct Record {
            static let Id = "566ed9290351d817555158cc"
        }
    }

    override func setUp() {
        super.setUp()

        // Set up a survey instance we can use for testing
        self.testSetupSurvey()
        
    }
    
    func testSetupSurvey(){
        
        var surveyJson: AnyObject?
             
        let surveyExpectation = expectationWithDescription("Alamofire Survey Request")
        
        Alamofire.request(.GET, Constants.Survey.Url)
            .responseJSON { response in
                if let json = response.result.value {
                    surveyJson = json
                    self.survey = Mapper<Survey>().map(surveyJson)
                    
                    XCTAssert(self.survey!.id == Constants.Survey.Id)
                    surveyExpectation.fulfill()
                    
                }
        }
        
        waitForExpectationsWithTimeout(5.0, handler: nil)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
   
    
}
