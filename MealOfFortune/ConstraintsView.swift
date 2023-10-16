//
//  Constraints.swift
//  MealOfFortune
//
//  Written by Timothy Gedney

import SwiftUI

struct ConstraintsView: View {
	@State var lat: Double //latitude
	@State var lon: Double //longitude
	@ObservedObject var api = DataHouse()
	@ObservedObject var list = APICall()
	@State private var disableButton = false //prevents multiple views from being loaded
	@State private var showRandom = false //bool value for view switching
	@State private var showList = false //bool for list
	@State var lis: [String] = [""] //string array for recieved data
	let radiusButton = ["5", "10", "15", "25"];	let radiusArray = [8000, 16000, 24000, 40000]
	@State var rad: Int = 8000 //radius values ^
	let priceButton = ["$", "$$", "$$$", "$$$$"]; let priceArray = ["1", "2", "3", "4"]
	@State var price: String = "" //price values ^
	@State var priceToggle = [false, false, false, false] //bool for price
	@State var includeSaved = true
	@State var showInfo = false //shows info block about split decision
	@State var term: String = "restaurants,food"
	//icon searchwords & bools
	let catFood = ["bbq,smokehouse", "breakfast_brunch,pancakes,waffles", "burgers", "cafes,themedcafes,bubbletea,coffee,coffeeroasteries,tea,internetcafe", "chinese,cantonese,dimsum,hainan,shanghainese,szechuan,hkcafe,mongolian,taiwanese", "chicken_wings,chickenshop", "mexican,newmexican,tex-mex,empanadas", "pizza", "ramen", "salad", "sandwiches,delis,cheesesteaks", "sushi,conveyorsushi", "vegan", "vegetarian"] //14
	let catNight = ["bars,drivethrubars,irish_pubs,pubs,sportsbars,divebars,poolhalls,lounges,tikibars", "beerbar,beergardens", "cocktailbars,champagne_bars,vermouthbars,whiskeybars,wine_bars,speakesies", "danceclubs,pianobars,musicvenues,countrydancehalls,jazzandblues,gaybars"] //4
	let catAct = ["museums,galleries,artmuseums,gardens,childrenmuseums", "zoos,aquariums,pettingzoos", "escapegames", "football,tennis,basketballcourts,golf,battingcages,baseballfields,squash,badminton,bocceball,pickleball"] //4
	let artW = ["museums,galleries,artmuseums,gardens,childrenmuseums", "", "", ""] //4
	let catShop = ["fashion,sunglasses,accessories,hats,lingerie,menscloth,womenscloth,shoes,vintage,tradclothing,watches,swimwear,leather,clothingrental,bespoke", "media,bookstores,comicbooks,mags,musicvideo,videogamestores,videoandgames,vinyl_records", "homeandgarden,appliances,furniture,grillingequipment,hardware,holidaydecorations,homedecor,kitchenandbath,kitchensupplies,lightingstores,gardening,outdoorfurniture,paintstores,pumpkinpatches,rugs,shedsandoutdoorstorage,tableware,poolbilliards", "deptstores,discountstore,dutyfreeshops,shoppingcenters,outlet_stores,personal_shopping,popupshops"] //4
	@State var artCat = ""
	@State var artCall: Bool = false
	@State var goHome: Bool = false
	@State var category: String = ""
	@State var iconsFood = ["BBQ", "Breakfast", "Burgers", "Cafe", "Central Asian", "Chicken", "Mexican", "Pizza", "Ramen", "Salad", "Sandwiches", "Sushi", "Vegan", "Vegetarian"]
	@State var iconsNight = ["Pub & Dive", "Beer Bar", "Cocktail Bar", "Club & Music"]
	@State var iconsActivity = ["Museums", "Zoo", "Escape Game", "Sports"]
	@State var iconsShop = ["Clothing", "Media", "Home", "Mall"]
	@State var iconFoodToggle: [Bool] = [false, false, false, false, false, false, false, false, false, false, false, false, false, false]
	@State var iconNightToggle: [Bool] = [false, false, false, false]
	@State var iconActivityToggle: [Bool] = [false, false, false, false]
	@State var iconShopToggle: [Bool] = [false, false, false, false]
	@State var iconCount: Int = 0
	@State var icon4: [Int] = [-1, -1, -1, -1] //keeps track of the 4 icons for split decision
	@State public var index: Int = -1
	@StateObject var ratio = NumbersOnly() //ratio object from SplitDecision view
	var fill: Bool {
			for i in 0..<ratio.value.count { if (ratio.value[i] != "") { return true } }
			return false } //checks that a ratio is filled in for split decision
	let active = "atvrentals,bikerentals,airsoft,amusementparks,waterparks,aquariums,zoos,pettingzoos,archery,axethrowing,badminton,baseballfields,basketballcourts,battingcages,beaches,boating,bobsledding,bocceball,bowling,bubblesoccer,bungeejumping,canyoneering,carousels,challenegecourses,climbing,dartarenas,discgolf,diving,freediving,scuba,escapegames,fishing,flyboarding,gokarts,golf,gun_ranges,hanggliding,hiking,lakes,horseracing,horsebackriding,hot_air_balloons,indoor_playcenter,jetskis,kiteboarding,lasertag,mini_golf,mountainbiking,nudist,paddleboarding,paintball,paragliding,parasailing,parks,dog_parks,skate_parks,pickleball,playgrounds,racingexperience,rafting,recreation,rock_climbing,sailing,scavengerhunts,skatingrinks,skydiving,sledding,snorkeling,football,squash,surfing,swimmingpools,tennis,trampoline,tubing,wildlifehunting,zipline,zorbing"
	let art = "arcades,virtualrealitycenters,galleries,museums,artmuseums,childrenmuseums,bingo,gardens,cabaret,casinos,movietheaters,driveintheater,outdoormovies,culturalcenter,eatertainment,farms,attractionfarms,pickyourown,ranches,festivals,hauntedhouses,lancenters,makerspaces,musicvenues,jazzandblues,observatories,planetarium,opera,paintandsip,theater,rodeo,psychic_astrology,astrologers,mystics,psychicmediums,psychics,wineries,winetastingroom"
	@State var isLoading = false //bool for loading screen
	@State var rest = loadBusinesses(id: "", name: "", image_url: "", is_closed: true, url: "", rating: 0.0, price: "", display_address: [""], callPhone: "" ,display_phone: "", distance: 0.0)

	var body: some View {
		ZStack(alignment: .center) {
			VStack {
				ScrollView (.vertical, showsIndicators: true) {
					VStack {
						Spacer()
						HStack { //4 buttons that only allow one selection at a time
							Text("Max Distance:")
								.font(.system(size: 24, design: .rounded))
							ForEach(0..<radiusButton.count) { i in
								Button(action: { self.rad = radiusArray[i] }) {
									if (self.rad == self.radiusArray[i]) {
										SmallButtonSelect(name: self.radiusButton[i], toggle: true)
									} else {
										SmallButtonSelect(name: self.radiusButton[i], toggle: false)
									}
								}
							}
						}
						Divider().frame(height: 2).background(ColorManager.InverseColor)
						HStack { //4 buttons that allow 0, 1, 2, 3, or 4 buttons at once
							Text("Price Range:").font(.system(size: 24, design: .rounded))
							ForEach(0..<priceButton.count) { i in
								Button(action: { priceToggle[i].toggle() }) {
									SmallButtonSelect(name: self.priceButton[i], toggle: priceToggle[i])
								}
							}
						}
						Divider().frame(height: 2).background(ColorManager.InverseColor)
						//term selection, changes icons shown based on term
						TermSelect(term: self.$term, iconFoodToggle: self.$iconFoodToggle, iconNightToggle: self.$iconNightToggle, iconActivityToggle: self.$iconActivityToggle, iconShopToggle: self.$iconShopToggle, iconCount: self.$iconCount, icon4: self.$icon4)
						//icons react to term
						if (term == "restaurants,food") { IconSelect(icons: iconsFood, iconToggle: self.$iconFoodToggle, iconCount: self.$iconCount, icon4: self.$icon4)
						} else if (term == "nightlife") { IconSelect(icons: iconsNight, iconToggle: self.$iconNightToggle, iconCount: self.$iconCount, icon4: self.$icon4)
						} else if (term == "active") { IconSelect(icons: iconsActivity, iconToggle: self.$iconActivityToggle, iconCount: self.$iconCount, icon4: self.$icon4)
						} else if (term == "shopping") {
							IconSelect(icons: iconsShop, iconToggle: self.$iconShopToggle, iconCount: self.$iconCount, icon4: self.$icon4) }
						VStack {
							HStack { //split decision allows 4 icons at once
								Text("Split Decision").font(.system(size: 30, design: .rounded))
								Button(action: { self.showInfo = true }) {
									Image(systemName: "info.circle").imageScale(.large).foregroundColor(ColorManager.InverseColor)
								}.alert(isPresented: Binding<Bool>(get: { return showInfo }, set: { p in showInfo = p })) {
									Alert(title: Text("Split Decision Info"), message: Text("Use Split Decision to vote on what's more desired out of your selections. \nMaxiumum: 4 Categories at Once"), dismissButton: .default(Text("Dismiss"))) }
							}
							if (iconCount > 1) { //appears when 2 or more icons are selected
								//tracks 4 icons based on term selected
								if (term == "restaurants,food") { SplitDecision(icons: iconsFood, iconToggle: iconFoodToggle, icon4: icon4)
								} else if (term == "nightlife") { SplitDecision(icons: iconsNight, iconToggle: iconNightToggle, icon4: icon4)
								} else if (term == "active") { SplitDecision(icons: iconsActivity, iconToggle: iconActivityToggle, icon4: icon4)
								} else if (term == "shopping") { SplitDecision(icons: iconsShop, iconToggle: iconShopToggle, icon4: icon4)
								}
								Button(action: { //clears ratios entered
									ratio.clear()
									self.closeKey(true)
								}) { Text("Clear Ratio")
									.font(.title).foregroundColor(Color.white).frame(width: 200.0, height: 50.0)
									.background(ColorManager.USCRed).cornerRadius(25.0) }
							}
						}
					}
				}
				ZStack {
					HStack {
						GeometryReader { geometry in //fills button to screen size
							Button(action: { //button for list view
								if (self.disableButton != true) { //checks that another button hasn't been pressed first
									list.count = nil
									disableButton = true //disables other buttons
									self.closeKey(true)
									isLoading = true //loading screen
									price = setPrice() //calls price func
									if (!fill) { //checks if ratios were entered
										//fills category term for api call
										if (term == "restaurants,food") {
											category = setORCategory(cat: catFood, iconToggle: iconFoodToggle)
										} else if (term == "nightlife") {
											category = setORCategory(cat: catNight, iconToggle: iconNightToggle)
										} else if (term == "active") {
											category = setORCategory(cat: catAct, iconToggle: iconActivityToggle)
										} else if (term == "shopping") {
											category = setORCategory(cat: catShop, iconToggle: iconShopToggle)
										}
									} else {
										//split decision
										index = ratioSelect() //gets ratio
										//selects category winner
										if (term == "restaurants,food") { category = catFood[index]
										} else if (term == "nightlife") { category = catNight[index]
										} else if (term == "active") { category = catAct[index]
										} else if (term == "shopping") { category = catShop[index] }
									}
									//makes api calls
									if (term == "active" && category == "" && !artCall) {
										list.clearList()
										list.getData(lat: lat, lon: lon, term: term, cat: active, rad: rad, price: price, multi: 1)
										list.getData(lat: lat, lon: lon, term: "arts", cat: art, rad: rad, price: price, multi: 1)
									} else if (term == "active") {
										list.clearList()
										if (artCall) {
											list.getData(lat: lat, lon: lon, term: "arts", cat: artCat, rad: rad, price: price, multi: 1)
										}
										if (category != "") {
											list.getData(lat: lat, lon: lon, term: "active", cat: category, rad: rad, price: price, multi: 1)
										}
									} else {
										list.getData(lat: lat, lon: lon, term: term, cat: category, rad: rad, price: price)
									}
									artCall = false; artCat = ""
									/*self.showList = true*/
									DispatchQueue.global(qos: .userInitiated).async{
										while(true){
											if(list.count==nil){
												//isLoading = true
											}else{
												isLoading = false
												self.showList = true
												disableButton = false
												break
											}
										}
									}
									
								}
							}) { //button text and formatting
								Text("List").font(.title).foregroundColor(Color.white).frame(width: geometry.size.width, height: 100.0)
									.background(ColorManager.USCRed).cornerRadius(25.0)
							}
						}
						GeometryReader { geometry in //same comments from above apply here
							Button(action: { //button for random resturant
								if (self.disableButton != true) {
									list.count = nil
									disableButton = true
									self.closeKey(true)
									isLoading = true
									price = setPrice()
									if (!fill) {
										if (term == "restaurants,food") {
											category = setORCategory(cat: catFood, iconToggle: iconFoodToggle)
										} else if (term == "nightlife") {
											category = setORCategory(cat: catNight, iconToggle: iconNightToggle)
										} else if (term == "active") {
											category = setORCategory(cat: catAct, iconToggle: iconActivityToggle)
										} else if (term == "shopping") {
											category = setORCategory(cat: catShop, iconToggle: iconShopToggle)
										}
									} else {
										index = ratioSelect()
										if (term == "restaurants,food") { category = catFood[index]
										} else if (term == "nightlife") { category = catNight[index]
										} else if (term == "active") { category = catAct[index]
										} else if (term == "shopping") { category = catShop[index] }
									}
									if (term == "active" && category == "") {
										list.clearList()
										list.getData(lat: lat, lon: lon, term: term, cat: active, rad: rad, price: price, multi: 1)
										list.getData(lat: lat, lon: lon, term: "arts", cat: art, rad: rad, price: price, multi: 1)
									} else if (term == "active") {
										list.clearList()
										if (artCall) {
											list.getData(lat: lat, lon: lon, term: "arts", cat: artCat, rad: rad, price: price, multi: 1)
										}
										if (category != "") {
											list.getData(lat: lat, lon: lon, term: "active", cat: category, rad: rad, price: price, multi: 1)
										}
									} else {
										list.getData(lat: lat, lon: lon, term: term, cat: category, rad: rad, price: price) }
									artCall = false; artCat = ""
									DispatchQueue.global(qos: .userInitiated).async{
										while(true){
											//print(String(list.count ?? -1) )
											if(list.count == nil){
												//isLoading = true
											}else if(list.count == 0){  // special case for rand view to avoid crash on randomeElement call
												isLoading = false
												disableButton = false
												self.showRandom = true
												rest = loadBusinesses(id: "", name: "0", image_url: "", is_closed: false, url: "", rating: 0.0, price: "", display_address: [""], callPhone: "", display_phone: "", distance: 0.0)
												break
											}
											else if(list.loadedBusinesses.count > 0 ){
												DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
													isLoading = false
													rest = list.loadedBusinesses.randomElement()!
													disableButton = false
													self.showRandom = true
												}
												break
											}
										}
									}
									
								}
							}) {
								Text("Random").font(.title).foregroundColor(Color.white).frame(width: geometry.size.width, height: 100.0)
									.background(ColorManager.USCRed).cornerRadius(25.0)
							}
						}
					}.offset(y: 5)
					NavigationLink(destination: RandomView(rest: rest), isActive: $showRandom) { EmptyView() } //link to random view
					NavigationLink(destination: ListView(list: list), isActive: $showList) { EmptyView() } //link to list view
				}.frame(height: 120.0).background(ColorManager.SameColor)
			}.navigationBarTitle(Text(""), displayMode: .inline).environmentObject(ratio)
			.navigationBarItems(trailing: ( //adds home button and link to home view
				Button(action: { self.goHome = true }) {
							Image(systemName: "house")
										.imageScale(.large)
										.foregroundColor(ColorManager.InverseColor)	}))
			NavigationLink(destination: HomeView().navigationBarHidden(true), isActive: $goHome) { EmptyView() }

			if (isLoading) { //loading screen overlays view
				if (term == "restaurants,food") {
					LoadingView(fill: fill, icons: iconsFood, index: index)
				} else if (term == "nightlife") {
					LoadingView(fill: fill, icons: iconsNight, index: index)
				} else if (term == "active") {
					LoadingView(fill: fill, icons: iconsActivity, index: index)
				} else if (term == "shopping") {
					LoadingView(fill: fill, icons: iconsShop, index: index)
				}
			}
		}.onTapGesture(count: 1, perform: { self.closeKey(true) }) //closes keyboard
	}
	
	//adds selected prices to price value for api call, returns String
	func setPrice() -> String {
		var p = ""
		for i in 0..<priceToggle.count {
			if (priceToggle[i] && p != "" && i > 0) {
				p += ",\(priceArray[i])"
			} else if (priceToggle[i]) {
				p += priceArray[i]
			}
		}
		return p
	}
	
	//adds cateogries to cat value for api call, returns String
	func setORCategory(cat: [String], iconToggle: [Bool]) -> String { //OR's categories
		var c = ""
		for i in 0..<iconToggle.count {
			if (iconToggle[i] && term == "active" && cat[i].contains(artW[i])) {
				artCall = true
				if (iconToggle[i] && artCat != "" && i > 0) {
					artCat += ",\(cat[i])"
				} else if (iconToggle[i]) {
					artCat += cat[i]
				}
			} else {
				if (iconToggle[i] && c != "" && i > 0) {
					c += ",\(cat[i])"
				} else if (iconToggle[i]) {
					c += cat[i]
				}
			}
		}
		return c
	}
	
	//randomly selects ratio based on numbers provided, returns Int
	func ratioSelect() -> Int {
		var sel: Int = 0
		var activePos: [Int:Int] = [:]
		var ratioArr: [Int] = []
		let ratioList = ratio.get()
		
		for (index, elem) in ratioList.enumerated() {
			if (elem == "" && icon4.contains(index)) { activePos[index] = 1 }
			if (elem != "" && elem != "0") {
				if (Int(elem) ?? 0 > 99) { activePos[index] = 99
				} else { activePos[index] = Int(elem) }
			}
		}
		
		for (indexNum, count) in activePos {
			for _ in 1...count { ratioArr.append(indexNum) }
		}
		
		sel = ratioArr[Int.random(in: 0...ratioArr.count-1)]
		
		return sel
	}
}
