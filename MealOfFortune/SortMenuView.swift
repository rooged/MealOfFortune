//
//  SortMenuView.swift
//  MealOfFortune
//
//  Created by Adam Kenvin on 3/28/21.
//

import SwiftUI



struct SortMenuView: View {
    @State var show = false
    @ObservedObject var list: APICall
    
    var body: some View {
        
        VStack{
            if(show){ //toggle to show sort menu view
                Button(action: {
                    list.loadedBusinesses.sort{ // sort by distance
                        $0.distance < $1.distance
                    }
                }) {
                    Text("Distance").font(.system(size: 22))
                        //.font(.foregroundColor(Color.white).background(ColorManager.USCRed).cornerRadius(20.0))
                }.padding(5)
                Button(action: {
                    list.loadedBusinesses.sort{ // sort by rating
                        $0.rating > $1.rating
                    }
                }) {
                    Text("Rating").font(.system(size: 22))
                }.padding(5)
                Button(action: {
                    list.loadedBusinesses.sort{ // sort by price 
                        $0.price < $1.price
                    }
                }) {
                    Text("Price").font(.system(size: 22))
                }.padding(5)
                
            }
            Button(action: { //button to expand list
                show.toggle()
            }) {
                Text("Sort By").font(.system(size: 27))
            }.padding(5)
        }.animation(.spring()).foregroundColor(Color.white).background(ColorManager.USCRed).cornerRadius(10.0)
    }
}


/*struct SortMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SortMenuView()
    }
}*/
