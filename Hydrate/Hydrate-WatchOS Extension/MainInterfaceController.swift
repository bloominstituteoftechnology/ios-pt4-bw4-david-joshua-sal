//
//  MainInterfaceController.swift
//  Hydrate-WatchOS Extension
//
//  Created by Joshua Rutkowski on 6/16/20.
//  Copyright © 2020 Hydrate. All rights reserved.
//

import WatchKit
import CoreData
import UIKit
import HealthKit


class MainInterfaceController: WKInterfaceController {
    
    //MARK: IBOutlets
    @IBOutlet weak var backgrounImageProgressGroup: WKInterfaceGroup!
    
    @IBOutlet weak var waterPercentageLabel: WKInterfaceLabel!
    
//    let intakeEntryController = IntakeEntryController()
    

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    //MARK: Actions
    //not needed direct connection to addDrinkInterfaceController
    

}
