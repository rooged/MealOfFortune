//
//  SavedView.swift
//  MealOfFortune
//
//  Created by Christopher on 11/26/20.
//  Edit by Dennis Perea
//

import SwiftUI

struct SavedView: View {
	@State var goHome: Bool = false
    @State var api: DataHouse
	@Binding var businesses: [loadBusinesses]
	var cloudKitManager = CloudKit()
	
	var body: some View {
		List {
			ForEach(self.businesses, id: \.id) { item in
				NavigationLink(destination: RandomView(rest: item)) {
					ListSelect(rest: item)
				}
			}.onDelete(perform: { indexSet in
				indexSet.forEach {businesses.remove(at: $0) }
				api.deleteSaved(indexSet: indexSet)
			})
		}.navigationBarTitle(Text(""), displayMode: .inline)
		.navigationBarItems(trailing: (
			Button(action: { self.goHome = true }) {
						Image(systemName: "house")
									.imageScale(.large)
									.foregroundColor(ColorManager.InverseColor)	}))
		NavigationLink(destination: HomeView().navigationBarHidden(true), isActive: $goHome) { EmptyView() }
	}
}

