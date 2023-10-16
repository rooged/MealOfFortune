//
//  DataHouse.swift
//  MealOfFortune
//
//  Written by Ben & Tim

import Foundation
import SwiftUI

class DataHouse: ObservableObject, Identifiable {
    @ObservedObject var data = APICall()
	@Published var savedCount: Int? = nil

    //passes variables to api call
	func getData(lat: Double, lon: Double, term: String = "restaurant,food", cat: String = "", rad: Int = 8000, price: String = "", multi: Int = 0) {
		DispatchQueue.global(qos: .utility).async{
			self.data.getData(lat: lat, lon: lon, term: term, cat: cat, rad: rad, price: price, multi: multi)
		}
	}
	//Get random will retrieve the data for a randomly selected restaurant from the list of restaurants returned
	//by the api call
    func getRandom() -> [String] {
		var randomList: [String] = []
		if (data.count != 0) {
			let range: Int? = data.nameList.count
			let num = Int.random(in: 0..<range!)
			randomList.append(data.nameList[num])
			randomList.append(data.addressList[num])
			randomList.append(data.displayPhoneList[num])
			randomList.append(data.priceList[num])
			randomList.append(String(data.ratingList[num]))
			randomList.append(data.urlList[num])
			randomList.append(data.idList[num])
			randomList.append(data.distanceList[num])
			randomList.append(data.phoneList[num])
			randomList.append(data.addressList[num].replacingOccurrences(of: "\n", with: "+"))
			randomList.append(data.linkList[num]) //index 10
			return randomList
		} else {
			randomList = ["0"]
			return randomList
		}
    }
	//getSpecific will retrieve the data for a specific restaurant from the list of restaurants
	//returned by the api call
	func getSpecific(num: Int) -> [String] {
		var randomList: [String] = []
		if (data.count != 0) {
			randomList.append(data.nameList[num])
			randomList.append(data.addressList[num])
			randomList.append(data.displayPhoneList[num])
			randomList.append(data.priceList[num])
			randomList.append(String(data.ratingList[num]))
			randomList.append(data.urlList[num])
			randomList.append(data.idList[num])
			randomList.append(data.distanceList[num])
			randomList.append(data.phoneList[num])
			randomList.append(data.addressList[num].replacingOccurrences(of: "\n", with: "+"))
			randomList.append(data.linkList[num]) //index 10
			return randomList
		} else {
			randomList = ["0"]
			return randomList
		}
	}

    func getSaved() -> [loadBusinesses] {
        let cloudKitManager: CloudKit = CloudKit()
        let yelpIDs: [String] = cloudKitManager.getRecords()

        for id in yelpIDs {
            data.getInfoFromID(yelpID: id)
			savedCount = 0
        }
		savedCount = data.savedBusinesses.count
		return data.savedBusinesses
    }

	func deleteSaved(indexSet: IndexSet) {
		let cloudKitManager: CloudKit = CloudKit()
		for index in indexSet {
			cloudKitManager.deleteRecord(recordID: self.data.savedBusinesses[index].id)
		}
		self.data.savedBusinesses.remove(atOffsets: indexSet)
	}

    func getImage() -> UIImage {
        let url = URL(string: data.urlList[0])
        let data = try? Data(contentsOf: url!)
        let image = UIImage(data: data!)
        return image!
    }
}
