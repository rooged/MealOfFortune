//
//  IconSelect.swift
//  MealOfFortune
//
//  Written by Timothy Gedney

import SwiftUI

struct IconSelect: View {
	var icons: [String] //icon array (pictures)
    @Binding var iconToggle: [Bool] //bool for icon to see whats selected
	@Binding var iconCount: Int //number of icons selected
	@Binding var icon4: [Int] //first 4 icons selected
	@EnvironmentObject var ratio: NumbersOnly //ratios for split decision
    
    var body: some View {
        ScrollView (.horizontal, showsIndicators: false) {
			HStack { //double Hstacks for horizontal scrolling of icons
				ForEach(0..<icons.count) { i in
					if ((i % 2) == 0) {
						Button(action: { //buttons allow multiple selections
							iconToggle[i].toggle()
							if (iconToggle[i]) {
								iconCount += 1
								get4(index: i)
							} else {
								iconCount -= 1
								if (icon4.contains(i)) { remove(index: i) }
								if (iconCount < 2) { ratio.clear() }
							}
						}) { IconView(name: icons[i]) }.frame(width: 90, height: 90).background(iconToggle[i] ? ColorManager.USCRed : ColorManager.SameColor).cornerRadius(10)
					}
				}
			}
			HStack {
				ForEach(0..<icons.count) { i in
					if ((i % 2) != 0) {
						Button(action: {
							iconToggle[i].toggle()
							if (iconToggle[i]) {
								iconCount += 1
								get4(index: i)
							} else {
								iconCount -= 1
								if (icon4.contains(i)) { remove(index: i) }
								if (iconCount < 2) { ratio.clear() }
							}
						}) { IconView(name: icons[i]) }.frame(width: 90, height: 90).background(iconToggle[i] ? ColorManager.USCRed : ColorManager.SameColor).cornerRadius(10)
					}
				}
			}
		}
        Divider().frame(height: 2).background(ColorManager.InverseColor)
    }
	
	//returns the first 4 icons selected
	func get4(index: Int) {
		for i in 0..<icon4.count {
			if (icon4[i] == -1) {
				icon4[i] = index
				break
			}
		}
	}
	
	//removes an icons from the 4 at a given index
	func remove(index: Int) {
		for i in 0..<icon4.count {
			if (icon4[i] == index) {
				icon4[i] = -1
				ratio.clearIndex(index: index)
				break
			}
		}
		for i in 0..<icon4.count - 1 {
			if (icon4[i] == -1 && icon4[i + 1] != -1) {
				icon4[i] = icon4[i + 1]
				icon4[i + 1] = -1
			}
		}
		for i in 0..<icons.count {
			if (iconToggle[i] && !icon4.contains(i)) {
				get4(index: i)
				break
			}
		}
	}
}
