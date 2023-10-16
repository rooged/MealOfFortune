//
//  MealOfFortuneUITests.swift
//  MealOfFortuneUITests
//
//  Created by Benjamin on 10/21/20.
//

import XCTest

class MealOfFortuneUITests: XCTestCase {
    var app:XCUIApplication!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        app = XCUIApplication()
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLaunch() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
    //tests that a UI button is there and functional
    func testRandomButton() throws {
        let app = XCUIApplication()
        app.launch()
        
        //checks that the button is there
        XCTAssertTrue(app.buttons["Random Restaurant"].waitForExistence(timeout: 1))
        //checks that the button can be tapped
        app.buttons["Random Restaurant"].tap()
    }
    
    //This will test to make sure the "Something Specific" button is there and is clickable.
    func testSpecificButton() throws {
        let app = XCUIApplication()
        app.launch()
        
        XCTAssertTrue(app.buttons["Something Specific"].waitForExistence(timeout: 1))
        app.buttons["Something Specific"].tap()
    }
    
    //This will test to make sure the "List of Restaurants" button is there and is clickable.
    func testListButton() throws {
        let app = XCUIApplication()
        app.launch()
        
        XCTAssertTrue(app.buttons["List of Restaurants"].waitForExistence(timeout: 1))
        app.buttons["List of Restaurants"].tap()
    }
    
    //This will test to make sure the "Saved Restaurants" button is there and is clickable.
    func testSavedButton() throws {
        let app = XCUIApplication()
        app.launch()
        
        XCTAssertTrue(app.buttons["Saved Restaurants"].waitForExistence(timeout: 1))
        app.buttons["Saved Restaurants"].tap()
    }
}
