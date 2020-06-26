//
//  ChartsView.swift
//  Hydrate
//
//  Created by Joshua Rutkowski on 6/26/20.
//  Copyright © 2020 Hydrate. All rights reserved.
//

import SwiftUI

struct ChartsView: View {
    
    // Dummy data
    @State var dataPoints: [CGFloat] = [
    10, 20, 30 , 40, 50, 60, 70
    ]
    
    var body: some View {
        ZStack {
            Color(#colorLiteral(red: 0.2122643888, green: 0.2450331748, blue: 0.3367856145, alpha: 1))
            VStack (alignment: .leading) {
                VStack (alignment: .leading, spacing: 0){
                    Text("Water Intake")
                        .font(.system(size:24))
                        .fontWeight(.heavy)
                        .foregroundColor(Color(UIColor.undeadWhite))
                    Text("Weekly")
                    .foregroundColor(Color(UIColor.sicklySmurfBlue))
                }

                HStack (spacing: 16) {
                    BarView(value: dataPoints[0])
                    BarView(value: dataPoints[1])
                    BarView(value: dataPoints[2])
                    BarView(value: dataPoints[3])
                    BarView(value: dataPoints[4])
                    BarView(value: dataPoints[5])
                    BarView(value: dataPoints[6])

                }.padding(.top, 0)
                    .animation(.default)
            }
            
        }
    }
}


struct BarView: View {
    var value: CGFloat = 0
    
    var body: some View {
        VStack {
            ZStack (alignment: .bottom) {
                Capsule().frame(width: 30, height: 150)
                    .foregroundColor(Color(UIColor.ravenClawBlue90))
                Capsule().frame(width: 30, height: value)
                    .foregroundColor(Color(UIColor.sicklySmurfBlue))
            }
            Text("D").padding(.top, 0)
            .foregroundColor(Color(UIColor.undeadWhite))
            
        }
    }
}

struct ChartsView_Previews: PreviewProvider {
    static var previews: some View {
        ChartsView()
    }
}
