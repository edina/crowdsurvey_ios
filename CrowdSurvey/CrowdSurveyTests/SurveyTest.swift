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

@testable import CrowdSurvey

class SurveyTest: XCTestCase {
    
    var survey: Survey?
    
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
        
        self.survey = Mapper<Survey>().map(surveyJson)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCreateSurveyFromJson() {
        let id = "566ed9b30351d817555158cd"
        let title = "OPAL Tree Health"
        
        if let survey = self.survey {
            XCTAssert(survey.id == id)
            XCTAssert(survey.title == title)
        }
    }
    
    func testSurveyDescriptionJson() {
        let id = "566ed9b30351d817555158cd"
        let title = "OPAL Tree Health"
        
        // print(survey!.description)
        
        if let jsonData = self.survey!.description.dataUsingEncoding(NSUTF8StringEncoding) {
            let json = JSON(data: jsonData)
            
            XCTAssert(json["id"].stringValue == id)
            XCTAssert(json["title"].stringValue == title)
        }
    }
    
}
