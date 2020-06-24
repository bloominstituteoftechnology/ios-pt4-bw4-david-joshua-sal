//
//  DailyLogController.swift
//  Hydrate
//
//  Created by David Wright on 6/23/20.
//  Copyright © 2020 Hydrate. All rights reserved.
//

import Foundation
import CoreData

class DailyLogController {
    
    // MARK: - Public
    
    var dailyLogs: [DailyLog] = []
    
    var allIntakeEntries: [IntakeEntry] = [] {
        didSet {
            updateDailyLogs()
        }
    }
    
    init() {
        fetchAllIntakeEntries()
    }
    
    // MARK: - Private
    
    fileprivate var coreDataStack = CoreDataStack.shared
    
    fileprivate func fetchAllIntakeEntries() {
        let fetchRequest: NSFetchRequest<IntakeEntry> = IntakeEntry.fetchRequest()
        let timeSortDescriptor = NSSortDescriptor(key: #keyPath(IntakeEntry.timestamp), ascending: false)
        fetchRequest.sortDescriptors = [timeSortDescriptor]
        
        do {
            let intakeEntries = try coreDataStack.mainContext.fetch(fetchRequest)
            self.allIntakeEntries = intakeEntries
        } catch let error as NSError {
            print("Error fetching: \(error), \(error.userInfo)")
            self.allIntakeEntries = []
        }
    }
    
    fileprivate func updateDailyLogs() {
        let allDates = allIntakeEntries.compactMap { $0.timestamp?.startOfDay } // removes .hour, .minute, .second, etc. granularity from timestamps
        let daysWithIntakeEntries = Array(Set(allDates)) // removes duplicates (each day appears only once)
        
        var dailyLogs: [DailyLog] = []
        
        for day in daysWithIntakeEntries {
            let entries = allIntakeEntries.filter { $0.timestamp?.startOfDay == day }
            dailyLogs.append(DailyLog(date: day, entries: entries))
        }
        
        self.dailyLogs = dailyLogs.sorted { $0.date > $1.date }
    }
}
