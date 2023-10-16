//
//  testList.swift
//  MealOfFortuneTests
//
//  Created by Ben on 4/24/21.
//


import XCTest
@testable import MealOfFortune

class testList: XCTestCase {
    //this tests the apicall to make sure a list is generated
    func testListCreation() {
        let list = APICall()
        list.getData(lat:37.7749, lon:122.4194)
        DispatchQueue.main.async {
            XCTAssertTrue (list.loadedBusinesses.count != 0)
        }
    }
}
