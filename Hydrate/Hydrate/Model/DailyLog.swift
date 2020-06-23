//
//  DailyLog.swift
//  Hydrate
//
//  Created by David Wright on 6/23/20.
//  Copyright © 2020 Hydrate. All rights reserved.
//

import Foundation
import CoreData

class DailyLog {
    
    // Properties
    var date: Date
    var entries: [IntakeEntry]
    
    var totalIntakeAmount: Int {
        Int(entries.reduce(0) { $0 + $1.intakeAmount })
    }
    
    // Initializers
    init(date: Date = Date(), entries: [IntakeEntry]) {
        self.date = date.startOfDay
        self.entries = entries
    }
    
    /*// This conveniece initializer might be used later on. Delete if unused.
    init(date: Date = Date()) {
        self.date = date.startOfDay

        let fetchRequest: NSFetchRequest<IntakeEntry> = IntakeEntry.fetchRequest()
        let datePredicate = NSPredicate(format: "(%K >= %@) AND (%K < %@)",
                                        #keyPath(IntakeEntry.timestamp), date.startOfDay as NSDate,
                                        #keyPath(IntakeEntry.timestamp), date.startOfNextDay as NSDate)
        fetchRequest.predicate = datePredicate

        do {
            let intakeEntries = try CoreDataStack.shared.mainContext.fetch(fetchRequest)
            self.entries = intakeEntries
        } catch let error as NSError {
            print("Error fetching: \(error), \(error.userInfo)")
            self.entries = []
        }
    }
    */
}
