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
    
//    let intakeEntryController = IntakeEntryController() -- unable to access coreData
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
    
    func authorizeHealthKit() {
        HealthKitSetupHelper().authorize { (authorized, error) in
            guard authorized else {
                let baseMessage = "HealthKit Authorization Failed"
                
                if let error = error {
                    print("\(baseMessage). Reason: \(error.localizedDescription)")
                } else {
                    print(baseMessage)
                }
                
                return
            }
            print("HealthKit Successfully Authorized")
            self.startObservingChanges()
        }
    }
    
    //observe changes to healthApp
    func startObservingChanges() {
        let query: HKObserverQuery = HKObserverQuery(sampleType: HealthKitWaterDataStore.waterType, predicate: nil, updateHandler: self.waterChangedHandler)
                healthKitStore.execute(query)
    }
    //water level changed
    func waterChangedHandler(query: HKObserverQuery, completionHandler: @escaping HKObserverQueryCompletionHandler, error: Error?) {
            guard error == nil else {
            print("failed trigger \(String(describing: error))")
            return
        }
            self.readWater()
            completionHandler()
    }
    //read water levels
    private func readWater() {
        HealthKitWaterDataStore().readWaterData(completion: {total in
        print("total water: \(total)") //TODO Convert to Percentage
        DispatchQueue.main.async {
            self.waterPercentageLabel.setText("\(total) %") //currently in ML
        }
    })
}
    //write water levels back to Store - Not on this screen o
    private func writeWater(amount: Double) {
        HealthKitWaterDataStore().writeWaterData(amount: amount)
    }

    //MARK: Actions
    //not needed direct connection to addDrinkInterfaceController
    

}
