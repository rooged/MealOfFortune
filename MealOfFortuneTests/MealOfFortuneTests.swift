//
//  MealOfFortuneTests.swift
//  MealOfFortuneTests
//
//  Created by Benjamin on 10/21/20.
//

import XCTest
@testable import MealOfFortune

class MealOfFortuneTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            let view = HomeView()
            usleep(400000)
            _ = view.userLat
            _ = view.userLon
        }
    }
    
    func testLongLat() throws{ //test case for obtaining user location
        let view = HomeView()
        _ = LocationManager()
        usleep(400000)
        let lat = view.userLat
        let lon = view.userLon
        XCTAssertTrue(lat != 0.1, "Latitude:  \(lat)")
        XCTAssertTrue(lon != 0.1, "Longitude: \(lon)")
    }

}
