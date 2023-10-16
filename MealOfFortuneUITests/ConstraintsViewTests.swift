//
//  ConstraintsViewTests.swift
//  MealOfFortuneUITests
//
//  Created by Timothy Gedney on 4/24/21.
//

import XCTest

class ConstraintsViewTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    //this tests that all of the distance buttons work
    func testDistance() throws {
        let app = XCUIApplication()
        app.launch()
        
        _ = app.buttons["Something Specific"].waitForExistence(timeout: 1)
        app.buttons["Something Specific"].tap()
        
        _ = app.buttons["10"].waitForExistence(timeout: 1)
        app.buttons["10"].tap()
        app.buttons["15"].tap()
        app.buttons["5"].tap()
        app.buttons["25"].tap()
    }
    
    //this tests that the price buttons work
    func testPrice() throws {
        let app = XCUIApplication()
        app.launch()
        
        _ = app.buttons["Something Specific"].waitForExistence(timeout: 1)
        app.buttons["Something Specific"].tap()
        
        _ = app.buttons["$"].waitForExistence(timeout: 1)
        app.buttons["$"].tap()
        app.buttons["$$"].tap()
        app.buttons["$$$"].tap()
        app.buttons["$$"].tap()
        app.buttons["$$$$"].tap()
        app.buttons["$"].tap()
    }
    
    //this tests that the icons and types buttons work
    func testIcons() throws {
        let app = XCUIApplication()
        app.launch()
        
        _ = app.buttons["Something Specific"].waitForExistence(timeout: 1)
        app.buttons["Something Specific"].tap()
        
        app.buttons["Restaurants"].tap()
        app.buttons["Burgers"].tap()
        app.buttons["Nightlife"].tap()
        app.buttons["Beer Bar"].tap()
        app.buttons["Restaurants"].tap()
        app.buttons["Cafe"].tap()
    }
}
