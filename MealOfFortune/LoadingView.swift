//
//  LoadingView.swift
//  MealOfFortune
//
//  Written by Ben & Tim

import SwiftUI

struct LoadingView: View {
    let fill: Bool
    let icons: [String]
    let index: Int
    
	//Layout for the blurred out loading screen reused while lists are loading before view changes.
    var body: some View {
		if (!fill) {
			ZStack {
				Rectangle().blur(radius: 350)
				ProgressView("Loading...").frame(width: 100, height: 100)
					.foregroundColor(ColorManager.InverseColor).background(ColorManager.SameColor).cornerRadius(15)
			}
		} else {
			ZStack {
				ColorManager.SameColor.edgesIgnoringSafeArea(.all)
				VStack {
					//added to loading view which type was selected for split decision while loading selected restaurant
					Image(icons[index]).resizable().scaledToFit().frame(width: 350, height: 350)
					Text("\(icons[index]) Won!")
						.font(.title).foregroundColor(ColorManager.InverseColor)
					ProgressView("Loading...").frame(width: 100, height: 100)
						.foregroundColor(ColorManager.InverseColor).background(ColorManager.SameColor).cornerRadius(15)
				}
            }
        }
    }
}
