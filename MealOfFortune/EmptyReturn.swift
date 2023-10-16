//
//  EmptyReturn.swift
//  MealOfFortune
//
//  Written by Timothy Gedney

import SwiftUI

//loads default image to let the user know the list returned empty
struct EmptyReturn: View {
    var body: some View {
        Image("notFound")
            .resizable()
            .scaledToFit()
        Text("Whoops!")
            .font(.system(size: 50, design: .default)).multilineTextAlignment(.center)
        Text("No results were found.")
            .font(.system(size: 28, design: .default)).multilineTextAlignment(.center)
        Text("Tip: Try increasing the max distance or using more restaurant types!")
            .font(.system(size: 22, design: .rounded)).multilineTextAlignment(.center)
        Spacer()
    }
}
