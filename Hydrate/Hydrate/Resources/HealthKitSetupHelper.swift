//
//  HealthKitSetupHelper.swift
//  Hydrate
//
//  Created by Sal B Amer on 6/26/20.
//  Copyright © 2020 Hydrate. All rights reserved.
//

import Foundation
import HealthKit
    

public class HealthKitSetupHelper {
    
    enum HealthKitSetupErrors: Error {
        case notAvailOnDevice
        case dataTypeNotAvail
    }
    
    //Check to see if HealthKit is Avail on Device
    func authorize(completion: @escaping (Bool, Error?) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, HealthKitSetupErrors.notAvailOnDevice)
            return
        }
        
    // What datatypes do i want from HealthKit Store?
        guard let water = HKObjectType.quantityType(forIdentifier: .dietaryWater) else {
            completion(false, HealthKitSetupErrors.dataTypeNotAvail)
            return
        }
        
    //What objects should HealthKit Read/Write?
        let healthKitTypesToWrite: Set<HKSampleType> = [water]
        let healthKitTypesToRead: Set<HKObjectType> = [water]
        
    //Request Auth
        HKHealthStore().requestAuthorization(toShare: healthKitTypesToWrite,
                                             read: healthKitTypesToRead,
                                             completion: completion)
    }
}
