//
//  HomeView.swift
//  MealOfFortune
//
//  Written by Tim, Benjamin, Adam, Christopher, & Dennis

import SwiftUI
import CoreLocation
import MapKit

struct HomeView: View {
	init() { //this turns off multitouch
		UIView.appearance().isExclusiveTouch = true
		for subView in UIView.appearance().subviews { subView.isExclusiveTouch = true }
	}
	@ObservedObject var locationManager = LocationManager() //location manager access
	var userLat: Double { return locationManager.lastLocation?.coordinate.latitude ?? 0 }
	var userLon: Double { return locationManager.lastLocation?.coordinate.longitude ?? 0 }
	@ObservedObject var api = DataHouse() //instance of DataHouse for api call
	@State private var showList = false //bool value for view switching
	@State private var showRandom = false //shows random view
	@State private var showConstraints = false //shows constraints view
	@State private var showSaved = false
	@State private var disableButton = false //prevents multiple views from being loaded
	@State var lis: [String] = [""]
	@State var lat: Double = 0.0 //default latitude
	@State var lon: Double = 0.0 //default longitude
	@State var businesses: [loadBusinesses] = []
	@State var address: String = ""
	@State private var temp = CLLocationCoordinate2D(
		latitude: 34.000710, // coord?.lat
		longitude: -81.034813 // coor?.long
	)
	@ObservedObject var list = APICall()
	@State var rest = loadBusinesses(id: "", name: "", image_url: "", is_closed: true, url: "", rating: 0.0, price: "",display_address: [""], callPhone: "", display_phone: "", distance: 0.0)
	@State var isLoading: Bool = false //loading screen
	@State var currentLocation = false //bool on if current location is selected
	@State var removedPin = false //bool if user removed their pin
	@State var showInfo = false

	var body: some View {
		NavigationView {
			ZStack(alignment: .center){
				ZStack (alignment: .top) { //UI formatting of screen
					GeometryReader { geometry in //sets screen size without inifinity warning
						Rectangle().fill(ColorManager.USCRed).frame(width: geometry.size.width, height: geometry.size.height).offset(y: -400)
					}
					VStack(spacing: 2) {
						Text("Meal of Fortune")
							.font(.system(size: 55, design: .rounded)).foregroundColor(Color.white).offset(y: -60)
						ZStack{
							MapView(centerCoordinate: $temp, lat: $lat, lon: $lon, currentLocation: $currentLocation, removedPin: $removedPin).offset(y: -20)
							VStack{
								HStack{
									Spacer()
								
							Button(action: { self.showInfo = true }) {
								Image(systemName: "info.circle").imageScale(.large).foregroundColor(ColorManager.InverseColor)
							}.alert(isPresented: Binding<Bool>(get: { return showInfo }, set: { p in showInfo = p })) {
								Alert(title: Text("How to use the map"), message: Text("Tap and hold to drop a pin to search around.\nSingle tap to remove the pin and search around your current location."), dismissButton: .default(Text("Dismiss"))) }
							}
								Spacer()
							}.offset(y: -10)
						}
						Spacer()
						VStack {
							HStack {
								Button(action: { //button to list of restaurants
									//pin down means pulling from non-user location
									if (removedPin) { currentLocation = false }
									isLoading = true //loading screen
									list.count = nil
									//checks if buttons are disabled
									if (self.disableButton != true) {
										disableButton = true //disables all buttons
										point()
										list.getData(lat: lat, lon: lon)
										DispatchQueue.global(qos: .userInitiated).async{
											while(true){ // wait till list is populated, allows for min loading time and on demand display
												if(list.count==nil){
													//isLoading = true
												}else{
													isLoading = false
													self.showList = true
													break
												}
											}
										}
									}
								}) { HomeButton(title: "List of Restaurants") }.onAppear() { disableButton = false }.accessibility(identifier: "List of Restaurants")
								Button(action: { //button to random resturants, same comments^
									if (removedPin) { currentLocation = false }
									isLoading = true
									list.count = nil
									if (self.disableButton != true) {
										disableButton = true
										point()
										list.getData(lat: lat, lon: lon)
										DispatchQueue.global(qos: .userInitiated).async{
											while(true){
												if(list.count == nil){
													//isLoading = true
												}else if(list.count == 0){ // special case for rand view to avoid crash on randomeElement call
													isLoading = false
													disableButton = false
													self.showRandom = true
													rest = loadBusinesses(id: "", name: "0", image_url: "", is_closed: false, url: "", rating: 0.0, price: "", display_address: [""],callPhone: "" ,display_phone: "", distance: 0.0)
													break
												}else if(list.loadedBusinesses.count > 0 ){
													print(String(list.loadedBusinesses.count))
													DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
														isLoading = false
														rest = list.loadedBusinesses.randomElement()!
														self.showRandom = true
													}
													break
												}
											}
										}
									}
								}) { HomeButton(title: "Random Restaurant") } }
							HStack{
								Button(action: { //button to constraints view, same comments^
									if (self.disableButton != true) {
										disableButton = true
										point()
										self.showConstraints = true
									}
								}) { HomeButton(title: "Something Specific") }
								Button(action: { //button to saved view
									isLoading = true
									if (self.disableButton != true) {
										api.savedCount = nil
										disableButton = true
										businesses.removeAll()
										DispatchQueue.global(qos: .userInitiated).async{
										businesses = api.getSaved()
										while(true){
											if(api.savedCount != nil){
												isLoading = false
												self.showSaved = true
												break
											}
										}
										}
									}
								}) { HomeButton(title: "Saved Restaurants") }
							}
						}
						//nav links to views
						NavigationLink(destination: ListView(list: list).accessibility(identifier: "listView"), isActive: $showList) {      EmptyView() }
						NavigationLink(destination: RandomView(rest: rest), isActive: $showRandom) { EmptyView() }
						NavigationLink(destination: ConstraintsView(lat: lat, lon: lon), isActive: $showConstraints) { EmptyView() }
						NavigationLink(destination: SavedView(api: api, businesses: self.$businesses), isActive: $showSaved) { EmptyView() }
					}.onAppear { api.data.savedBusinesses.removeAll() }
				}
				if (isLoading) { LoadingView(fill: false, icons: [""], index: 0) }
			}//ZStack line 34
		}.accentColor(ColorManager.InverseColor)
	}
	
	func point() {
		if (lat == 0 && lon == 0) {
			lat = userLat
			lon = userLon
		}
	}
}

//custom color accessors created here
struct ColorManager {
	static let USCRed = Color("USCRed") //red color used in various places
	static let InverseColor = Color("InverseColor") //inverses to users dark/light mode
	static let SameColor = Color("SameColor") //same as dark/light mode
	static let ButtonOutline = Color("ButtonOutline") //outline of buttons
}
