//
//  HomeButton.swift
//  MealOfFortune
//
//  Written by Timothy Gedney

import SwiftUI

struct HomeButton: View {
    var title: String
    
    //view for buttons on home screen, fill screen to fit and standard formatting
    var body: some View {
        GeometryReader { g in
        Text(title)
            .font(.system(size: 30, design: .rounded)).multilineTextAlignment(.center).foregroundColor(Color.white).frame(width: g.size.width, height: g.size.height).background(ColorManager.USCRed).cornerRadius(20.0)//.frame(height:100).padding(5)
        }
    }
}
