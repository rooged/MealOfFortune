//
//  CloudKitTests.swift
//  MealOfFortuneTests
//
//  Created by Christopher Moyer on 1/27/21.
//

import XCTest
@testable import MealOfFortune

class CloudKitTests: XCTestCase {

    let testID = "eI0DpD2Xx8hFlk7eAdFCqQ"
    let testName = "Swan Oyster Depot"
    let cloudKitManager: CloudKit = CloudKit()

    override func setUp() {
        cloudKitManager.deleteRecord(recordID: testName)
        sleep(2)
    }
    
    override func tearDown() {
        cloudKitManager.deleteRecord(recordID: testName)
        sleep(2)
    }
    
    // Tests if a record can be saved to CloudKit and then retrieved again
    func testCKRecordSave() throws {
        
        /*let saveResult = cloudKitManager.saveRecord(yelpID: testID, restaurantName: testName)
        XCTAssertEqual(saveResult, "Success")
    
        sleep(3)
        let savedIDs = cloudKitManager.getRecords()
        
        var successfulSave = false
        if (savedIDs.contains(testID)) {
            successfulSave = true
        }
        XCTAssertTrue(successfulSave)*/
    }

}
