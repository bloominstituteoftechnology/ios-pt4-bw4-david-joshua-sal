//
//  IntakeEntryController.swift
//  Hydrate
//
//  Created by David Wright on 6/23/20.
//  Copyright © 2020 Hydrate. All rights reserved.
//

import Foundation
import CoreData

class IntakeEntryController {
    
    // MARK: - Properties
    
    var intakeEntries: [IntakeEntry] = []
    
    var allIntakeEntries: [IntakeEntry] = []
    var daysWithIntakeEntries: [Date] = []
    var dailyTotals: [Int] = []
    
    var coreDataStack = CoreDataStack.shared
    
    var totalIntakeAmount: Int {
        Int(intakeEntries.reduce(0) { $0 + $1.intakeAmount })
    }
    
    var allIntakeEntriesFetchRequest: NSFetchRequest<IntakeEntry> = {
        let fetchRequest: NSFetchRequest<IntakeEntry> = IntakeEntry.fetchRequest()
        let timeSortDescriptor = NSSortDescriptor(key: #keyPath(IntakeEntry.timestamp), ascending: false)
        fetchRequest.sortDescriptors = [timeSortDescriptor]
        return fetchRequest
    }()
    
    func getAllDatesWithIntakeEntries() -> [Date] {
        let allDates = allIntakeEntries.compactMap { $0.timestamp?.startOfDay }
        return Array(Set(allDates)).sorted()
    }
    
    func getAllIntakeTotals() -> [Int] {
        return daysWithIntakeEntries.compactMap { fetchIntakeTotal(for: $0) }
    }
    
    func fetchIntakeTotal(for date: Date = Date()) -> Int {
        let fetchRequest = NSFetchRequest<NSDictionary>(entityName: "IntakeEntry")
        fetchRequest.resultType = .dictionaryResultType
        
        let sumExpressionDescription = NSExpressionDescription()
        sumExpressionDescription.name = "sumIntakeAmount"
        
        let intakeAmount = NSExpression(forKeyPath: #keyPath(IntakeEntry.intakeAmount))
        sumExpressionDescription.expression = NSExpression(forFunction: "sum:", arguments: [intakeAmount])
        sumExpressionDescription.expressionResultType = .integer32AttributeType
        
        fetchRequest.propertiesToFetch = [sumExpressionDescription]
        
        let datePredicate = NSPredicate(format: "(%K >= %@) AND (%K < %@)",
                                        #keyPath(IntakeEntry.timestamp), date.startOfDay as NSDate,
                                        #keyPath(IntakeEntry.timestamp), date.startOfNextDay as NSDate)
        fetchRequest.predicate = datePredicate
        
        do {
            let results = try coreDataStack.mainContext.fetch(fetchRequest)
            let resultDictionary = results.first!
            let sumIntakeAmount = resultDictionary["sumIntakeAmount"] as! Int
            return sumIntakeAmount
        } catch let error as NSError {
            print("Error fetching: \(error), \(error.userInfo)")
            return 0
        }
    }
    
    // MARK: - CRUD Methods
    
    func loadIntakeEntries(for date: Date = Date()) {
        self.intakeEntries = fetchIntakeEntries(for: date)
    }
    
    func fetchIntakeEntries(for date: Date = Date()) -> [IntakeEntry] {
        let fetchRequest: NSFetchRequest<IntakeEntry> = IntakeEntry.fetchRequest()
        let datePredicate = NSPredicate(format: "(%K >= %@) AND (%K < %@)",
                                        #keyPath(IntakeEntry.timestamp), date.startOfDay as NSDate,
                                        #keyPath(IntakeEntry.timestamp), date.startOfNextDay as NSDate)
        fetchRequest.predicate = datePredicate
        
        do {
            let intakeEntries = try coreDataStack.mainContext.fetch(fetchRequest)
            return intakeEntries
        } catch let error as NSError {
            print("Error fetching: \(error), \(error.userInfo)")
            return []
        }
    }
    
    func addIntakeEntry(withIntakeAmount intakeAmount: Int) {
        let intakeEntry = IntakeEntry(intakeAmount: intakeAmount)
        
        do {
            try CoreDataStack.shared.saveContext()
            intakeEntries.insert(intakeEntry, at: 0)
        } catch {
            print("Error adding intakeEntry: \(error)")
        }
    }
    
    func deleteIntakeEntry(_ intakeEntry: IntakeEntry) {
        let context = CoreDataStack.shared.mainContext
        do {
            context.delete(intakeEntry)
            try context.save()
            intakeEntries.removeAll(where: { $0 == intakeEntry })
        } catch {
            print("Error deleting intakeEntry: \(error)")
        }
    }
}
