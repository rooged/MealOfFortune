//
//  TermSelect.swift
//  MealOfFortune
//
//  Written by Timothy Gedney

import SwiftUI

struct TermSelect: View {
	@Binding var term: String
	let termButton = ["Restaurants", "Nightlife", "Activities", "Shopping"]
	//term searchwords
	let termArray = ["restaurants,food", "nightlife", "active", "shopping"]
	@Binding var iconFoodToggle: [Bool]
	@Binding var iconNightToggle: [Bool]
	@Binding var iconActivityToggle: [Bool]
	@Binding var iconShopToggle: [Bool]
	@Binding var iconCount: Int
	@Binding var icon4: [Int]
    
	//Displays the proper icons for selection based on the term that is highlighted. Eg. Activities will display museums,
	//escape games, sports and zoos while Restaurants will display icons for different types of food.
    var body: some View {
		HStack {
			Text(" Type:  ")
				.font(.system(size: 24, design: .rounded))
			//ScrollView (.horizontal, showsIndicators: false) {
			VStack {
				HStack {
					ForEach(0..<termButton.count) { i in
						if ((i % 2) == 0) {
							Button(action: { self.term = termArray[i]; reset() }) {
								Text(termButton[i]).padding()
									.font(.system(size: 20, design: .default))
									.foregroundColor(ColorManager.InverseColor).frame(height: 35.0).background(self.term == termArray[i] ? ColorManager.USCRed : ColorManager.SameColor).cornerRadius(10)
									.overlay(RoundedRectangle(cornerRadius: 10).stroke(ColorManager.InverseColor, lineWidth: 1))
							}
						}
					}
				}
				HStack {
					ForEach (0..<termButton.count) { i in
						if ((i % 2) != 0) {
							Button(action: { self.term = termArray[i]; reset() }) {
								Text(termButton[i]).padding()
									.font(.system(size: 20, design: .default))
									.foregroundColor(ColorManager.InverseColor).frame(height: 35.0).background(self.term == termArray[i] ? ColorManager.USCRed : ColorManager.SameColor).cornerRadius(10)
									.overlay(RoundedRectangle(cornerRadius: 10).stroke(ColorManager.InverseColor, lineWidth: 1))
							}
						}
					}
				}
			}
		}
		Divider().frame(height: 2).background(ColorManager.InverseColor)
	}
	//When term is changed from restaurants to non restaurants all selected terms are unselected.
	func reset() {
		for i in 0..<iconFoodToggle.count { //reset food
			iconFoodToggle[i] = false
		}
		for i in 0..<iconNightToggle.count { //reset nightlife
			iconNightToggle[i] = false
		}
		for i in 0..<iconActivityToggle.count {
			iconActivityToggle[i] = false
		}
		for i in 0..<iconShopToggle.count {
			iconShopToggle[i] = false
		}
		iconCount = 0
		for i in 0..<icon4.count {
			icon4[i] = -1
		}
	}
}
