//
//  IntakeEntry+Convenience.swift
//  Hydrate
//
//  Created by David Wright on 6/23/20.
//  Copyright © 2020 Hydrate. All rights reserved.
//

import Foundation
import CoreData

extension IntakeEntry {
    
    @discardableResult
    convenience init(intakeAmount: Int,
                     timestamp: Date = Date(),
                     identifier: UUID = UUID(),
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        self.intakeAmount = Int32(intakeAmount)
        self.timestamp = timestamp
        self.identifier = identifier
    }
    
    static func ==(lhs: IntakeEntry, rhs: IntakeEntry) -> Bool {
        lhs.identifier == rhs.identifier
    }
}
