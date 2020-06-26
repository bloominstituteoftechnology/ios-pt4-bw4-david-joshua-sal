//
//  HealthKitWaterDataStore.swift
//  Hydrate
//
//  Created by Sal B Amer on 6/26/20.
//  Copyright © 2020 Hydrate. All rights reserved.
//

import Foundation
import HealthKit

public class HealthKitWaterDataStore {
    
    //what datapoint from HealthKit?
    static let waterType = HKSampleType.quantityType(forIdentifier: .dietaryWater)!
    
    //Read Water based on Calendar Date
    public func readWaterData(completion: @escaping (_ totalWater: Double) -> Void) {
        let healthKitStore = HKHealthStore()
        let calendar = Calendar.current
        let today = Date()
        let midnight = calendar.startOfDay(for: today)
        
        //last 24 hours
        let last24Hours = HKQuery.predicateForSamples(withStart: midnight, end: today, options: .strictEndDate)
        
        let waterQueryRequest = HKSampleQuery(sampleType: HealthKitWaterDataStore.waterType, predicate: last24Hours, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, samples, error) in
            
            guard error == nil,
                let quantitySample = samples as? [HKQuantitySample] else {
                    print("Error unable to get samples of previous data: \(String(describing: error))")
                    return
            }
            
            let total = quantitySample.reduce(0.0) { $0 + $1.quantity.doubleValue(for: HKUnit.literUnit(with: .milli)) }
            DispatchQueue.main.async {
                completion(total)
            }
        }
        healthKitStore.execute(waterQueryRequest)
    }
    
    // Send water samples from device to HealthKitStore ( For Current Day Only )
    public func writeWaterData(amount: Double) {
        let healthKitStore = HKHealthStore()
        let waterDrankQuantity = HKQuantity(unit: HKUnit.literUnit(with: .milli), doubleValue: amount)
        let today = Date()
        let waterQuantitySample = HKQuantitySample(type: HealthKitWaterDataStore.waterType, quantity: waterDrankQuantity, start: today, end: today)
        
        healthKitStore.save(waterQuantitySample) { (success, error) in
            print("Writing to Health Kit Store Finished - success: \(success); error: \(String(describing: error))")
        }
    }
    
}
