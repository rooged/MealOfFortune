//
//  ListItem.swift
//  MealOfFortune
//
//  Written by Timothy Gedney and Dennis Perea

import SwiftUI

struct ListSelect: View {
    
    var rest: loadBusinesses
    
    //view for each item on the list view, constant formatting
    var body: some View {
        VStack() {
            HStack() {
                VStack(alignment: .leading) {
                    Text(rest.name).bold().font(.system(size: 20))
                    Spacer()
                        .frame(height: 10)
                    /*Text(rest.display_address[0])
                    if (rest.display_phone != "N/A") {
                        Text(rest.display_phone)
                    }*/
                    Text(String(format: "%.2f", rest.distance) + " miles away")

                    switch(rest.rating){
                        case 0.0: Image("small_0")
                        case 1.0: Image("small_1")
                        case 1.5: Image("small_1_half")
                        case 2.0: Image("small_2")
                        case 2.5: Image("small_2_half")
                        case 3.0: Image("small_3")
                        case 3.5: Image("small_3_half")
                        case 4.0: Image("small_4")
                        case 4.5: Image("small_4_half")
                        case 5.0: Image("small_5")
                        default: Text("No rating yet")
                    }
                    Image("Yelplogo").resizable().frame(width: 53, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                }
                Spacer()
                RemoteImage(url: rest.image_url)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 175, height: 175)
            }
        }
    }
}
