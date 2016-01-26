//
//  CrowdSurveyUITests.swift
//  CrowdSurveyUITests
//
//  Created by Colin Gormley on 11/01/2016.
//  Copyright © 2016 Edina. All rights reserved.
//

import XCTest

class CrowdSurveyUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let app = XCUIApplication()
        app.buttons["+"].tap()
        
        let cellCount = app.tables.cells.count
        XCTAssertEqual(cellCount, 26)
        
        let tablesQuery = app.tables
        let cell = tablesQuery.textFields["Enter answer…"]
        
        cell.tap()
  
        cell.typeText("Some test text")
        app.toolbars.buttons["Done"].tap()
        
    }
    
}
