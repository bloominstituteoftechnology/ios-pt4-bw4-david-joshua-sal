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
    var dayOfWeekLabels = [String]()
    var totalsToChart = [Int]()

    init() {
        updateDailyLogs()
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
                    Text("Last Seven Days")
                        .foregroundColor(Color(UIColor.undeadWhite65))
                }
                
                HStack (spacing: 16) {
                    BarView(value: CGFloat(totalsToChart[0]), label: dayOfWeekLabels[0])
                    BarView(value: CGFloat(totalsToChart[1]), label: dayOfWeekLabels[1])
                    BarView(value: CGFloat(totalsToChart[2]), label: dayOfWeekLabels[2])
                    BarView(value: CGFloat(totalsToChart[3]), label: dayOfWeekLabels[3])
                    BarView(value: CGFloat(totalsToChart[4]), label: dayOfWeekLabels[4])
                    BarView(value: CGFloat(totalsToChart[5]), label: dayOfWeekLabels[5])
                    BarView(value: CGFloat(totalsToChart[6]), label: dayOfWeekLabels[6])
                }.padding(.top, 0)
                    .animation(.default)
            }
            
        }
    }
}
// MARK: - BarView
struct BarView: View {
    var value: CGFloat = 0
    var label: String = ""
    
    var body: some View {
        VStack {
            ZStack (alignment: .bottom) {
                Capsule().frame(width: 30, height: 125)
                    .foregroundColor(Color(UIColor.ravenClawBlue90))
                Capsule().frame(width: 30, height: value)
                    .foregroundColor(Color(UIColor.sicklySmurfBlue))
            }
            Text(label).padding(.top, 0)
                .foregroundColor(Color(UIColor.undeadWhite65))
                .font(.system(size: 15, weight: .medium, design: .default))
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
        
        let lastSevenDailyLogs = Array(dailyLogs.suffix(7))
        
        let dayOfWeekFormatter = DateFormatter()
        dayOfWeekFormatter.dateFormat = "M/d"
        let calendar = Calendar.current
        let today = Date().startOfDay
        
        for dayOffset in -6...0 {
            let day = calendar.date(byAdding: .day, value: dayOffset, to: today)!
            dayOfWeekLabels.append(dayOfWeekFormatter.string(from: day))
            
            let dailyLog = lastSevenDailyLogs.first(where: { $0.date == day })
            let total = dailyLog?.totalIntakeAmount ?? 0
            totalsToChart.append(total)
        }
    }
}
