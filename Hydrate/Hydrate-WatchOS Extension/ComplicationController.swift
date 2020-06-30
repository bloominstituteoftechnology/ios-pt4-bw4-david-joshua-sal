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

enum PreferredUnit: Int {
    case milliliters
    case fluidOunces
}

class ComplicationController: NSObject, CLKComplicationDataSource {
    
    
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([])
    }
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        
        var currentWaterVolume: Double = 0.0
        var percentageOfDailyGoal: Double = 0.0
        
        let lastUpdated = UserDefaults.standard.value(forKey: "Hydrate_lastUpdated") as? Date ?? Date.distantFuture
        if Calendar.current.isDateInToday(lastUpdated) {
            currentWaterVolume = UserDefaults.standard.double(forKey: "Hydrate_currentWaterVolume")
            percentageOfDailyGoal = UserDefaults.standard.double(forKey: "Hydrate_percentageOfDailyGoal")
        }
        
        let fillFraction = Float(min(1.0, percentageOfDailyGoal))
        let displayPercentOfGoal = String(format: "%.0f%%", percentageOfDailyGoal * 100)
        let volInMilliliters = Measurement(value: currentWaterVolume, unit: UnitVolume.milliliters)
        
        let displayVolume: String
        let prefferedUnit = PreferredUnit(rawValue: UserDefaults.standard.integer(forKey: "Hydrate_preferredUnit"))
        
        if prefferedUnit == PreferredUnit.fluidOunces {
            displayVolume = String(format: "%.0f oz", volInMilliliters.converted(to: .fluidOunces).value)
        } else {
            displayVolume = String(format: "%.1f L", volInMilliliters.converted(to: .liters).value)
        }
        
        //switch view depending on complication family
        switch complication.family {
        case .graphicCircular:
            let template = CLKComplicationTemplateGraphicCircularClosedGaugeText()
            template.centerTextProvider = CLKSimpleTextProvider(text: "💧")
            template.gaugeProvider = CLKSimpleGaugeProvider(style: .fill, gaugeColor: #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), fillFraction: fillFraction)
            let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
            handler(entry)
        default:
            handler(nil)
        }
        
    }
    

}
