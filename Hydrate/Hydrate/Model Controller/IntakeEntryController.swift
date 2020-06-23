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
    var coreDataStack = CoreDataStack.shared
    
    var totalIntakeAmount: Int {
        Int(intakeEntries.reduce(0) { $0 + $1.intakeAmount })
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
    
    
}
