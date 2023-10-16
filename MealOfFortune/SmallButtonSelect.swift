//
//  SmallButtonSelect.swift
//  MealOfFortune
//
//  Written by Timothy Gedney

import SwiftUI

//layouts for small select buttons reused in constraintsView
struct SmallButtonSelect: View {
    var name: String
    var toggle: Bool
    
    var body: some View {
        Text(name)
            .foregroundColor(ColorManager.InverseColor).frame(width: 45.0, height: 45.0).background(toggle ? ColorManager.USCRed : ColorManager.SameColor).cornerRadius(15)
            .overlay(RoundedRectangle(cornerRadius: 15).stroke(ColorManager.InverseColor, lineWidth: 1))
    }
}
