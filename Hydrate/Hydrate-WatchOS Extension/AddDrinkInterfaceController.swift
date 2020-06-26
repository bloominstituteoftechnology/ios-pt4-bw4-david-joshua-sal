//
//  AddDrinkInterfaceController.swift
//  Hydrate-WatchOS Extension
//
//  Created by Sal B Amer on 6/24/20.
//  Copyright © 2020 Hydrate. All rights reserved.
//

import WatchKit
import Foundation
import HealthKit


class AddDrinkInterfaceController: WKInterfaceController {

    let healthKitStore = HKHealthStore()
    
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
    
    // Do i have to authorize again? No for now
    
    //MARK: Actions
    
    @IBAction func addEightOzBtn() {
        writeWater(amount: 240) // 8 oz = 240 ml
        popToRootController()
    }
    @IBAction func addSixteenOzBtn() {
        writeWater(amount: 473) // 16 oz = 473 oz
        popToRootController()
    }
    // custom button not needed direct segue
    
    //Add Water to HK Store
    private func writeWater(amount: Double) {
        HealthKitWaterDataStore().writeWaterData(amount: amount)
    }
    
    
}
