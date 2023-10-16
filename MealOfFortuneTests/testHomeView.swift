//
//  testHomeView.swift
//  MealOfFortuneTests
//
//  Created by Dennis Perea on 1/29/21.
//

import XCTest
@testable import MealOfFortune
class testHomeView: XCTestCase {
    
    override func setUp(){
        super.setUp()
    }

    override func tearDownWithError() throws {
        super.tearDown()
    }

    func testHomeViewLocation() throws {
        XCTAssertNotNil(HomeView().userLat, "Location is nil")
        XCTAssertNotNil(HomeView().userLon, "Longitude is nil")
    }

}
