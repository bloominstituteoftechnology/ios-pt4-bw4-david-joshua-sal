//
//  ComplicationController.swift
//  Hydrate-WatchOS Extension
//
//  Created by Sal B Amer on 6/30/20.
//  Copyright © 2020 Hydrate. All rights reserved.
//

import WatchKit
import ClockKit
import UIKit

class ComplicationController: NSObject, CLKComplicationDataSource {
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        <#code#>
    }
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        <#code#>
    }
    

}
