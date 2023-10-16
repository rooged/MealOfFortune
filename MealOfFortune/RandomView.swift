//
//  ThirdView.swift
//  MealOfFortune
//
//  Written by Ben, Tim, & Christopher

import SwiftUI

struct RandomView: View {
	
	//@Binding var lis: [String]
	@State var goHome: Bool = false //bool to go to home view
	
	@State private var chooseApp = false //bool for choosing maps app
	@State private var mapError = false //error from maps
	@State private var chooseYelp = false //bool for choosing yelp
	@State private var showAlert = false
	@State private var errorSaving = false
	@State private var error = ""
	var rest: loadBusinesses
	
	var body: some View {
		if (rest.name != "0") { //if there isn't a return show empty view
			GeometryReader { g in
				VStack {
					RemoteImage(url: rest.image_url) //photo
						.aspectRatio(contentMode: .fit).frame(width: g.size.width, height: g.size.height * 5/10).padding(.bottom, g.size.height * 1/12)
					VStack(alignment: .leading, spacing: 6) {
						Text(rest.name).font(.title).bold().fixedSize(horizontal: false, vertical: true) //name
						let direction = "+" + rest.name.replacingOccurrences(of: " ", with: "+") + ",+" + rest.display_address[0].replacingOccurrences(of: " ", with: "+").replacingOccurrences(of: "\n", with: "+") //formats url for directions
						Button(action: { self.chooseApp = true }) { //address
							Text(rest.display_address[0]).underline().fixedSize(horizontal: false, vertical: true) }.actionSheet(isPresented: $chooseApp) {
								//creates popup asking which app to open, sends url to maps app selected and sends user to the app
								ActionSheet(title: Text("Choose An App to Open"), message: nil, buttons: [.default(Text("Apple Maps")) { appleMap(direction: direction) }, .default(Text("Google Maps")) { googleMap(direction: direction) }, .default(Text("Copy to Clipboard")) {
																											let mapsLink = "http://maps.apple.com/?daddr=\(direction)"
																											UIPasteboard.general.string = mapsLink }, .cancel(Text("Dismiss"))])
							}.alert(isPresented: $mapError) { //error message if app can't open
								Alert(title: Text("Error: Unable to Open"), message: Text("Make Sure the App is Downloaded and You Are Connected to the Internet"), dismissButton: .default(Text("Dismiss"))) }
						if (rest.display_phone != "N/A") {
							Button(action: { //creates url for phone number call, calls number if user selects it
								let plus = CharacterSet(charactersIn: "+")
								var number = rest.callPhone.trimmingCharacters(in: plus)
								number.remove(at: number.startIndex)
								let url: NSURL = URL(string: "tel://" + number)! as NSURL
								UIApplication.shared.open(url as URL)
							}) { Text(rest.display_phone).underline() } //phone
						}
						if (rest.price != "N/A") { Text(rest.price) } //price
						//Switch on rating to change rating from number to Yelp asset standard
						switch(Double(rest.rating)) {
						case 0.0: Image("regular_0")
						case 1.0: Image("regular_1")
						case 1.5: Image("regular_1_half")
						case 2.0: Image("regular_2")
						case 2.5: Image("regular_2_half")
						case 3.0: Image("regular_3")
						case 3.5: Image("regular_3_half")
						case 4.0: Image("regular_4")
						case 4.5: Image("regular_4_half")
						case 5.0: Image("regular_5")
						default: Text("No rating yet")
						}
						Image("Yelplogo").resizable().frame(width: 53, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
						HStack {
							Text(String(format: "%.2f", rest.distance)  + " miles away") //distance
							Spacer()
							Button(action: { self.chooseYelp = true }) {
								Text("Yelp Page").underline() }.actionSheet(isPresented: $chooseYelp) {
									//creates popup asking what to do
									ActionSheet(title: Text("Choose An Option"), message: nil, buttons: [.default(Text("Open in Yelp")) {
										let url: NSURL = URL(string: rest.url)! as NSURL
										UIApplication.shared.open(url as URL)
									}, .default(Text("Copy to Clipboard")) { UIPasteboard.general.string = rest.url }, .cancel(Text("Dismiss"))]) }
						}
						Spacer()
						Button(action: {
							let cloudKitManager: CloudKit = CloudKit()
							error = cloudKitManager.saveRecord(yelpID: rest.id, restaurantName: rest.name)
							if error == "Success" { errorSaving = false
							} else { errorSaving = true }
							showAlert = true
						}, label: { Text("Save to List").underline() })
						.alert(isPresented: $showAlert) {
							if (errorSaving) {
								return Alert(title: Text("Error"), message: Text(self.error), dismissButton: .default(Text("Ok")))
							} else {
								return Alert(title: Text("Success"), message: Text("Save Successful!"), dismissButton: .default(Text("Ok")))
							}
						}
					}.padding().frame(height: g.size.height * 3/10)
				}.navigationBarTitle(Text(""), displayMode: .inline)
				.navigationBarItems(trailing: (
										Button(action: { self.goHome = true }) {
											Image(systemName: "house").imageScale(.large)
												.foregroundColor(ColorManager.InverseColor)	}))
				NavigationLink(destination: HomeView().navigationBarHidden(true), isActive: $goHome) { EmptyView() }
			}
		} else { EmptyReturn() }
	}
	
	//sends address url call to apple maps, opens app and starts directions
	func appleMap(direction: String) {
		if (UIApplication.shared.canOpenURL(URL(string: "http://maps.apple/com/")!)) {
			let appleURL: NSURL = URL(string: "http://maps.apple.com/?daddr=\(direction)")! as NSURL
			UIApplication.shared.open(appleURL as URL)
		} else {
			mapError = true
		}
	}
	
	//sends address url call to google maps, opens app and starts directions
	func googleMap(direction: String) {
		if (UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!)) {
			let googleURL: NSURL = URL(string: "comgooglemaps://?daddr=\(direction)")! as NSURL
			UIApplication.shared.open(googleURL as URL)
		} else {
			mapError = true
		}
	}
}
