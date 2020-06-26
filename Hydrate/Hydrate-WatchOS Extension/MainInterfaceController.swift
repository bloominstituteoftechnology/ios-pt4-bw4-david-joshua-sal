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
    @IBOutlet weak var waterPerDayRemainingLabel: WKInterfaceLabel!
    
//    let intakeEntryController = IntakeEntryController() -- unable to access coreData
    let healthKitStore = HKHealthStore()
    
  
    

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        readWater()
        animateBackgroungImageBasedOnPercentage()
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        readWater()
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        readWater()
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
    
    // animate backgroundgroup based on percentage
    func animateBackgroungImageBasedOnPercentage() {
        var images: [UIImage]! = []
        let percentage =  waterPercentageLabel.self// value of mlConversion
        for i in 0...100 {
            let name = "activity-\(i)"
            images.append(UIImage(named: name)!)
        }
        let progressImages = UIImage.animatedImage(with: images, duration: 0.0)
        backgrounImageProgressGroup.setBackgroundImage(progressImages)
    
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
    public func readWater() {
        HealthKitWaterDataStore().readWaterData(completion: {total in
        print("total water consumed so far today: \(total) ml") //TODO Convert to Percentage
            // TODO create function to convert from ml to oz
            // 100 oz = 2950 ml
            let mlConversion = Int(total/2950 * 100)// intake / 2950 ml
            let remainingOzConversion = Int((2950 - total) / 29.54)
        DispatchQueue.main.async {
            self.waterPercentageLabel.setText("\(mlConversion) %") //TODO - in Percentage currently in ML
            self.waterPerDayRemainingLabel.setText("\(remainingOzConversion) oz left") // 100 oz total per day
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
