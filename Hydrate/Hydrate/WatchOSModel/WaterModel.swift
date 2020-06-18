//
//  WaterModel.swift
//  Hydrate
//
//  Created by Sal B Amer on 6/18/20.
//  Copyright © 2020 Hydrate. All rights reserved.
//

import WatchConnectivity
import UIKit

class WaterModel {
    
    class WaterModel {
        var currentWater: Int
        var waterGoal: Int
        
        var progress: Int {
            get {
                return currentWater / waterGoal
            }
        }
        
        // iniitalize watergoal
        init(waterGoal: Int) {
            self.currentWater = 0
            self.waterGoal = waterGoal
        }
        
    }

}
