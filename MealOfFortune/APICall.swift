//
//  GetData2.swift
//  MealOfFortune
//
//  Written by Ben & Tim

import Foundation

import Foundation
import SwiftUI
import CoreLocation
import MapKit

public class APICall: ObservableObject {
    var nameList: [String] = []
    var addressList: [String] = []
    var displayPhoneList: [String] = []
    var phoneList: [String] = []
    var distanceList: [String] = []
    var idList: [String] = []
    var ratingList: [Double] = []
    var priceList: [String] = []
    var urlList: [String] = []
	var linkList: [String] = []
	@Published var count: Int? = nil
	
    
	@Published var loadedBusinesses: [loadBusinesses] = []
	@Published var savedBusinesses: [loadBusinesses] = []
	

    let locationManager = CLLocationManager()
	
	//relocation from datahouse
	func getData(lat: Double, lon: Double, term: String = "restaurant,food", cat: String = "", rad: Int = 8000, price: String = "", multi: Int = 0) {
		DispatchQueue.main.async{
			self.loadData(lat: lat, lon: lon, term: term, cat: cat, rad: rad, price: price, multi: multi)
		}
	}

    //passes in variables for yelps call
	func loadData(lat: Double, lon: Double, term: String = "restaurants", cat: String = "", rad: Int = 8000, price: String = "", multi: Int = 0) {
		if (multi == 0) {
			clearList() //clears arrays
		}
        let apikey = "" //removed api key for public repo
		//base url search
		var baseURL = "https://api.yelp.com/v3/businesses/search?term=\(term)"
        //optional category parameter, ignored if empty
        if (cat != "") {
            baseURL = baseURL + "&categories=\(cat)"
        }
        //optional price parameter, ignored if empty
        if (price != "") {
            baseURL = baseURL + "&price=\(price)"
        }
		//radius parameter, default is 5 miles (8000 meters), limits to 50, returns open
        baseURL = baseURL + "&radius=\(rad)&longitude=\(lon)&latitude=\(lat)&limit=50&open_now=true"
        
        let url = URL(string: baseURL)
                
        var req = URLRequest(url : url!)
        
        req.setValue("Bearer \(apikey)", forHTTPHeaderField: "Authorization")
        req.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: req) { (data, response, error) in
            if let err = error{
                print(err.localizedDescription)
            }
            do {
                let json = try  JSONDecoder().decode(jsonType.self, from: data!)
				//print(">>>>>", json, #line, "<<<<<<<<<")
				DispatchQueue.main.async {self.count = json.total}
				
				for i in json.businesses {
					DispatchQueue.main.async {
						let distance = Float((i.distance ?? 0)*0.000621371)
						var Iurl = ""
						var address = [""]
						if i.image_url?.first == "h" {
							//print(url)
							Iurl = i.image_url ?? "https://s3-media1.fl.yelpcdn.com/assets/srv0/styleguide/8f25535cd587/assets/img/brand_guidelines/fuoy@2x.png"
						} else {
							Iurl = "https://s3-media1.fl.yelpcdn.com/assets/srv0/styleguide/8f25535cd587/assets/img/brand_guidelines/fuoy@2x.png"
						}
						address[0] = i.location?.display_address.joined(separator: "\n") ?? " "
						self.loadedBusinesses.append(loadBusinesses(id: i.id ?? " ", name: i.name ?? " ", image_url: Iurl, is_closed: i.is_closed ?? false, url:i.url ?? " ", rating: i.rating ?? 0.0, price: i.price ?? " ", display_address: address,callPhone: i.phone ?? " ",display_phone: i.display_phone ?? " " , distance: distance ))
					}
                }
				
            } catch {
                print("caught")
            }
        }.resume()
    }
    
    //converts meters to miles for distance
    func calcDistance(distance: Double) -> String {
        return String(format: "%.2f", distance * 0.00062137)
    }
	
	//clears lists when a new call is performed
	func clearList() {
		loadedBusinesses.removeAll()
	}
    
    func getNames() -> [String] {
        return self.nameList
    }
    
    // Semaphore waits for the loadInfoFromID function to finish
    let sem = DispatchSemaphore.init(value: 0)
    
    // Takes a yelpID and adds all the business information to the saved business list
    func getInfoFromID (yelpID: String) {

        loadInfoFromID(id: yelpID)
        sem.wait()
    }
    
    func loadInfoFromID (id: String) {
        let apikey = "pNYHQnGt-25QDHtRyHE4FSa7m8VTU1PT_wfi6Uqwvce9aE2j4oZSNNq73PDZlTqSMAVPMCGbdQcxrhDDiANQYkHOk2ozYyIpkpEYbfoinvGlalYttFdMw-xtXMeQX3Yx"
        let stringURL = "https://api.yelp.com/v3/businesses/" + id
        
        let url = URL(string: stringURL)
        
        var req = URLRequest(url : url!)
        
        req.setValue("Bearer \(apikey)", forHTTPHeaderField: "Authorization")
        req.httpMethod = "GET"
        
		URLSession.shared.dataTask(with: req) { [self] (data, response, error) in
            if let err = error{
                print(err.localizedDescription)
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) //as! [String: Any]
                //print(">>>>>", json, #line, "<<<<<<<<<")
                guard let resp = json as? NSDictionary else {return}
				let name = (resp.value(forKey: "name") as? String ?? "N/A")
				let price = (resp.value(forKey: "price") as? String ?? "N/A")
                let display_address = resp.value(forKeyPath: "location.display_address") as? [String] ?? ["N/A", "N/A"]
				let callPhone = (resp.value(forKey: "phone") as? String ?? "N/A")
				let phone = (resp.value(forKey: "display_phone") as? String ?? "N/A")
                let image_url = (resp.value(forKey: "image_url") as? String ?? "N/A")
				let url = (resp.value(forKey: "url") as? String ?? "N/A")
				let rating = (resp.value(forKey: "rating") as? Double ?? 0.0)
				let is_closed = (resp.value(forKey: "is_closed") as? Bool ?? false)
				let lat = resp.value(forKeyPath: "coordinates.latitude") as? Double ?? 0.0
				let long = resp.value(forKeyPath: "coordinates.longitude") as? Double ?? 0.0
				
				let userLocation = locationManager.location
				let restaurantLocation = CLLocation(latitude: lat, longitude: long)
				let distance = userLocation!.distance(from: restaurantLocation)
				let business = loadBusinesses(id: id, name: name, image_url: image_url, is_closed: is_closed, url: url, rating: rating, price: price, display_address: display_address,callPhone: callPhone ,display_phone: phone, distance: Float(distance) * 0.00062137)
				if (business.name != "N/A") {
					self.savedBusinesses.append(business)
				}
				
				self.sem.signal()
				
            } catch {
                print("caught")
            }
        }.resume()
    }
	
	
}


//structs in fromat of yelp API call to allow use of JSONDecoder().decode to easily obtain info rather than JSONSerialization
struct jsonType:Codable{
	var businesses: [restaurant]
	var total: Int
}

//optionals to avoid crashes from values not returned from Yelp API
struct restaurant: Codable{
	
	var id: String?
	var name: String?
	var image_url: String?
	var is_closed: Bool?
	var url: String?
	var rating: Double?
	var price: String?
	var location: Location?
	var phone: String?
	var display_phone: String?
	var distance: Double?
	
}

struct Location: Codable{
	
	var display_address: [String]
  
}

// struct similar to restaurant but in the format needed to facilitate use around the rest of app
// no optionals
struct loadBusinesses: Identifiable {
	var id: String
	var name: String
	var image_url: String
	var is_closed: Bool
	var url: String
	var rating: Double
	var price: String
	var display_address: [String]
	var callPhone: String
	var display_phone: String
	var distance: Float
	
}
