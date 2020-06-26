//
//  ChartsView.swift
//  Hydrate
//
//  Created by Joshua Rutkowski on 6/26/20.
//  Copyright © 2020 Hydrate. All rights reserved.
//
import SwiftUI
import CoreData

struct ChartsView: View {
    
    let dailyLogController = DailyLogController()
    var dailyLogs: [DailyLog] = []
    var lastSevenDays: [DailyLog] = []
    
    var day1: CGFloat = 0
    var day2: CGFloat = 0
    var day3: CGFloat = 0
    var day4: CGFloat = 0
    var day5: CGFloat = 0
    var day6: CGFloat = 0
    var day7: CGFloat = 0
    
    init() {
        updateDailyLogs()
        
        checkIfIndexExists()
    }
    
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
                    BarView(value: day7)
                    BarView(value: day6)
                    BarView(value: day5)
                    BarView(value: day4)
                    BarView(value: day3)
                    BarView(value: day2)
                    BarView(value: day1)
                    
                }.padding(.top, 0)
                    .animation(.default)
            }
            
        }
    }
}
// MARK: - BarView
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

// MARK: - Extension
extension ChartsView {
    fileprivate mutating func checkIfIndexExists() {
        if ((0 < lastSevenDays.count ? lastSevenDays[0] : nil) != nil) {
            day1 = CGFloat(lastSevenDays[0].totalIntakeAmount)
        }
        
        if ((1 < lastSevenDays.count ? lastSevenDays[1] : nil) != nil) {
            day2 = CGFloat(lastSevenDays[1].totalIntakeAmount)
        }
        
        if ((2 < lastSevenDays.count ? lastSevenDays[2] : nil) != nil) {
            day3 = CGFloat(lastSevenDays[2].totalIntakeAmount)
        }
        
        if ((3 < lastSevenDays.count ? lastSevenDays[3] : nil) != nil) {
            day4 = CGFloat(lastSevenDays[3].totalIntakeAmount)
        }
        
        if ((4 < lastSevenDays.count ? lastSevenDays[4] : nil) != nil) {
            day5 = CGFloat(lastSevenDays[4].totalIntakeAmount)
        }
        
        if ((5 < lastSevenDays.count ? lastSevenDays[5] : nil) != nil) {
            day6 = CGFloat(lastSevenDays[5].totalIntakeAmount)
        }
        
        if ((6 < lastSevenDays.count ? lastSevenDays[6] : nil) != nil) {
            day7 = CGFloat(lastSevenDays[6].totalIntakeAmount)
        }
    }
    
    fileprivate mutating func updateDailyLogs() {
        let allIntakeEntries = dailyLogController.allIntakeEntries
        
        let allDates = allIntakeEntries.compactMap { $0.timestamp?.startOfDay } // removes .hour, .minute, .second, etc. granularity from timestamps
        let daysWithIntakeEntries = Array(Set(allDates)) // removes duplicates (each day appears only once)
        
        var dailyLogs: [DailyLog] = []
        
        for day in daysWithIntakeEntries {
            let entries = allIntakeEntries.filter { $0.timestamp?.startOfDay == day }
            dailyLogs.append(DailyLog(date: day, entries: entries))
        }
        
        self.dailyLogs = dailyLogs.sorted { $0.date > $1.date }
        
        let slice = dailyLogs.suffix(7)
        let weekArray = Array(slice)
        lastSevenDays = weekArray
        print(weekArray)
        
    }
}
