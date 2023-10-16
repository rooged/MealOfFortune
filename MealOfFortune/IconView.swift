//
//  IconView.swift
//  MealOfFortune
//
//  Written by Timothy Gedney

import SwiftUI

//Layout for reused restaurant/activity icons in constraints view
struct IconView: View {
    var name: String
    
    var body: some View {
        VStack {
            Image(name)
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
            if (name.count <= 9) {
                Text(name).foregroundColor(ColorManager.InverseColor)
            } else if (name.count == 10) {
                Text(name).foregroundColor(ColorManager.InverseColor).font(.system(size: 15))
            } else if (name.count > 10) {
                Text(name).foregroundColor(ColorManager.InverseColor).font(.system(size: 14))
            }
        }
    }
}
