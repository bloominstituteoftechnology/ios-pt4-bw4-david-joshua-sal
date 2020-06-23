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
    
    
}
