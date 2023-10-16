//
//  SecondView.swift
//  MealOfFortune
//
//  Written by Ben & Tim

import SwiftUI

struct ListView: View {
	
	//@ObservedObject var api: DataHouse
	@ObservedObject var list: APICall
	@State var goHome: Bool = false
	@State var showRandom: Bool = false
	//@State var list: [String] = [""]
	
	//Repeated ListSelect (formatted view of each Restaurants individual data) in List format for each restaurant
	//returned by api call. The view is formatted for propper displaying.
	var body: some View {
		if (list.count != 0) {
			ZStack{
				
				List(list.loadedBusinesses) { i in
					NavigationLink(destination: RandomView(rest: i)) {
						ListSelect(rest: i)
					}
				}.navigationBarTitle(Text(""), displayMode: .inline)
				.navigationBarItems(trailing: (
										Button(action: { self.goHome = true }) {
											Image(systemName: "house").imageScale(.large)
												.foregroundColor(ColorManager.InverseColor)	}))
				NavigationLink(destination: HomeView().navigationBarHidden(true), isActive: $goHome) { EmptyView() }
			
			VStack{
				Spacer()
				HStack{
					Spacer()
					SortMenuView(list:list)
				}.padding(5)
			}.padding(5)
			}
		}else{
			EmptyReturn()
		}
		
	}
}


