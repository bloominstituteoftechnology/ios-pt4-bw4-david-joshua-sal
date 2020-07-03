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
    
    func addIntakeEntry(withDate date: Date, intakeAmount: Int) {
        let intakeEntry = IntakeEntry(intakeAmount: intakeAmount, timestamp: date)
        
        do {
            try CoreDataStack.shared.saveContext()
        } catch {
            print("Error adding intakeEntry: \(error)")
        }
        
        let dailyLogDate = date.startOfDay
        
        if let dailyLog = dailyLogs.first(where: { $0.date == dailyLogDate }) {
            dailyLog.addEntry(intakeEntry)
        } else {
            addDailyLog(withIntakeEntry: intakeEntry)
        }
    }
    
    fileprivate func addDailyLog(withIntakeEntry intakeEntry: IntakeEntry) {
        let dailyLogDate = intakeEntry.timestamp!.startOfDay
        let dailyLog = DailyLog(date: dailyLogDate, entries: [intakeEntry])
        let indexToInsert = dailyLogs.firstIndex(where: { $0.date < dailyLogDate }) ?? dailyLogs.count
        
        dailyLogs.insert(dailyLog, at: indexToInsert)
    }
    
    func delete(_ dailyLog: DailyLog) {
        let context = coreDataStack.mainContext
        
        for intakeEntry in dailyLog.entries {
            context.delete(intakeEntry)
        }
        
        do {
            try context.save()
            dailyLogs.removeAll(where: { $0.date == dailyLog.date })
        } catch {
            print("Error deleting intakeEntry: \(error)")
        }
    }
    
    func delete(_ intakeEntry: IntakeEntry) {
        guard let entryDate = intakeEntry.timestamp?.startOfDay,
            let dailyLogIndex = dailyLogs.firstIndex(where: { $0.date == entryDate }) else { return }
        
        let context = coreDataStack.mainContext
        
        context.delete(intakeEntry)
        
        do {
            try context.save()
            let intakeEntries = fetchIntakeEntries(for: entryDate)
            if intakeEntries.count > 0 {
                dailyLogs[dailyLogIndex].removeEntry(intakeEntry)
            } else {
                dailyLogs.remove(at: dailyLogIndex)
            }
        } catch {
            print("Error deleting intakeEntry: \(error)")
        }
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
    
    fileprivate func fetchIntakeEntries(for date: Date = Date()) -> [IntakeEntry] {
        let fetchRequest: NSFetchRequest<IntakeEntry> = IntakeEntry.fetchRequest()
        let datePredicate = NSPredicate(format: "(%K >= %@) AND (%K < %@)",
                                        #keyPath(IntakeEntry.timestamp), date.startOfDay as NSDate,
                                        #keyPath(IntakeEntry.timestamp), date.startOfNextDay as NSDate)
        fetchRequest.predicate = datePredicate
        
        let sortDescriptor = NSSortDescriptor(keyPath: \IntakeEntry.timestamp, ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let intakeEntries = try coreDataStack.mainContext.fetch(fetchRequest)
            return intakeEntries
        } catch let error as NSError {
            print("Error fetching: \(error), \(error.userInfo)")
            return []
        }
    }
}
