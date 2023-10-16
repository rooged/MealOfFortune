//
//  CloudKit.swift
//  MealOfFortune
//
//  Created by Christopher and Dennis on 11/24/20.

import CloudKit

class CloudKit {
	let privateDatabase = CKContainer(identifier: "iCloud.MOF2").privateCloudDatabase
	
	// Saves the provided yelpID to the users private database
	// Also saves the restaurant name as the record ID
	func saveRecord(yelpID: String, restaurantName: String) -> String {
		let group = DispatchGroup()
		let id = CKRecord.ID(recordName: yelpID)
		let record = CKRecord(recordType: "Restaurant", recordID: id)
		var errorSavingRecord = true
		var saveError: String = ""
		
		group.enter()
		DispatchQueue.global().async {
			let operation = CKModifyRecordsOperation(recordsToSave: [record])
			operation.configuration.timeoutIntervalForRequest = 10
			operation.configuration.qualityOfService = .userInteractive
			
			operation.perRecordCompletionBlock = {
				record, error in
				
				if error == nil {
					print("Record Saved")
					errorSavingRecord = false
				} else {
					print("Error Saving Record")
					print(error!)
					errorSavingRecord = true
					if let ckerror = error as? CKError {
						if ckerror.code == CKError.serverRecordChanged {
							print(ckerror.code)
							saveError = "This resturant is already in your list!"
						}
					}
				}
			}
			
			operation.completionBlock = {
				if saveError == "" {
					saveError = "Unable to connect to CloudKit. Please try again later"
				}
				group.leave()
			}
			
			self.privateDatabase.add(operation)
		}
		
		group.wait()
		if (errorSavingRecord == false) {
			return "Success"
		} else {
			return saveError
		}
	}
	
	// Gets a list of the yelpIDs stored in the users private database
	// Will not return until operation is completed
	func getRecords() -> [String] {
		var yelpIDs: [String] = []
		
		let privateDatabase = CKContainer(identifier: "iCloud.MOF2").privateCloudDatabase
		let query = CKQuery(recordType: "Restaurant", predicate: NSPredicate(format: "TRUEPREDICATE"))
		
		let operation = CKQueryOperation(query: query)
		operation.configuration.timeoutIntervalForRequest = 15
		operation.configuration.qualityOfService = .userInteractive
		  
		let sem = DispatchSemaphore.init(value: 0)
		

		operation.recordFetchedBlock = { record in
			var id: String!
			id = record.recordID.recordName
			print("Printing ID " + id)
			yelpIDs.append(id)
		}
		
		operation.queryCompletionBlock = { cursor, error in
			sem.signal()
		}
		privateDatabase.add(operation)
		
		sem.wait()
		return yelpIDs
	}

	func deleteRecord(recordID: String) {
		let privateDatabase = CKContainer(identifier: "iCloud.MOF2").privateCloudDatabase
		let id = CKRecord.ID(recordName: recordID)
		
		let operation = CKModifyRecordsOperation(recordIDsToDelete: [id])
		privateDatabase.add(operation)
		print("Deleting Records")
		
		operation.perRecordCompletionBlock = {
			record, error in
			
			if error == nil {
				print("Record Deleted")
			} else {
				print("Error Deleting Record")
				print(error!)
			}
		}
	}

}
