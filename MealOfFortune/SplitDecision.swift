//
//  SplitDecision.swift
//  MealOfFortune
//
//  Written by Timothy Gedney

import SwiftUI

struct SplitDecision: View {
    var icons: [String] //icon array (pictures)
    var iconToggle: [Bool] //bool array of icons to find which are selected
	var icon4: [Int] //keeps track of the first 4 selected icons
	@EnvironmentObject var ratio: NumbersOnly //global func
    
    var body: some View {
		HStack () {
			//max 4 icons at once, has icon, name, and ratio for each one
			ForEach (0..<iconToggle.count) { i in
				if (iconToggle[i] == true && icon4.contains(i)) {
					VStack {
						IconView(name: icons[i]).frame(width: 90, height: 90)
						TextField("1", text: $ratio.value[i]).keyboardType(.decimalPad).font(.title).multilineTextAlignment(.center).frame(width: 45)
					}
				}
			}
		}.onTapGesture(count: 1, perform: { self.closeKey(true) }) //closes keyboard
    }
}

//extension to close force close keyboard
extension View {
	func closeKey(_ close: Bool) {
		UIApplication.shared.windows.forEach { $0.endEditing(close) }
	}
}

//class for keeping track of ratios, will only allows #'s to be entered
class NumbersOnly: ObservableObject {
	@Published var value: [String] = Array(repeating: "", count: 100) {
		didSet {
			for i in 0..<value.count { //filters out non-#'s
				let filtered = value[i].filter { $0.isNumber }
				if (value[i] != filtered) { value[i] = filtered }
			}
		}
	}
	
	func get() -> [String] { return value } //returns ratio array
	
	func clear() { for i in 0..<value.count { value[i] = "" } } //clears ratio array
	
	func clearIndex(index: Int) { value[index] = "" } //clears at specific index
}
