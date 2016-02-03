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
        struct Form{
            static let TakePhotoLabel = "Take a photo"
            static let Question1Label = "1. Date of survey"
            static let Question1TextRowTag = Question1Label + "_tag"
            static let Question2Label = "2. Who are you doing the Tree Health Survey with today?"
            static let Question3Label = "3. Are you involved in working with trees or forestry?"
            static let Question3TextRowTag = "3. Are you involved in working with trees or forestry?_tag"
            static let Question3Id = "form-radio-2"
            static let Question3Type = "radio"
            static let ImageQuestionLabel = "Take a photo"
            static let ImageQuestionImageRowTag = ImageQuestionLabel + "_imageTag"
            
            static let TestTextFormValue = "test text value"
            static let TextType = "text"
            static let ImageType = "image"
            static let validGreenColour = UIColor(
                red:0.1,
                green:0.8,
                blue:0.1,
                alpha:0.1)
            static let requiredRedColour = UIColor(
                red:1,
                green:0.1,
                blue:0.1,
                alpha:0.1)
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
