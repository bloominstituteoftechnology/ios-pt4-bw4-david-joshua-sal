//
//  ComplicationController.swift
//  Hydrate-WatchOS Extension
//
//  Created by Sal B Amer on 6/30/20.
//  Copyright © 2020 Hydrate. All rights reserved.
//

//import WatchKit
import ClockKit
//import UIKit

enum PreferredUnit: Int {
    case milliliters
    case fluidOunces
}

class ComplicationController: NSObject, CLKComplicationDataSource {
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([])
    }
    
    func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.showOnLockScreen)
    }
    
    //Populte timeline
    
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
        // graphic Circular
        case .graphicCircular:
            let template = CLKComplicationTemplateGraphicCircularClosedGaugeText()
            template.centerTextProvider = CLKSimpleTextProvider(text: "💧")
            template.gaugeProvider = CLKSimpleGaugeProvider(style: .fill, gaugeColor: #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), fillFraction: fillFraction)
            let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
            handler(entry)
        // graphic corner
        case .graphicCorner:
            let template = CLKComplicationTemplateGraphicCornerStackText()
            template.innerTextProvider = CLKSimpleTextProvider(text: "WATER: \(displayPercentOfGoal)")
            // add tint color here
            template.outerTextProvider = CLKSimpleTextProvider(text: "\(displayVolume)")
            // add tint color for outer text here
            let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
            handler(entry)
        // graphic bezel
        case .graphicBezel:
            let template = CLKComplicationTemplateGraphicBezelCircularText()
            let circularTemplate = CLKComplicationTemplateGraphicCircularClosedGaugeText()
            circularTemplate.centerTextProvider = CLKSimpleTextProvider(text: "💧")
            circularTemplate.gaugeProvider = CLKSimpleGaugeProvider(style: .fill, gaugeColor: #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), fillFraction: fillFraction)
            template.circularTemplate = circularTemplate
            template.textProvider = CLKSimpleTextProvider(text: "Water \(displayVolume) - \(displayPercentOfGoal)")
            let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
            handler(entry)
        // circular small
        case .circularSmall:
            let template = CLKComplicationTemplateCircularSmallRingText()
            template.textProvider = CLKSimpleTextProvider(text: "💧")
            template.fillFraction = fillFraction
            template.ringStyle = .closed
            //add tint color here
            let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
            handler(entry)
        //modular small
        case .modularSmall:
            let template = CLKComplicationTemplateModularSmallRingText()
            template.fillFraction = fillFraction
            template.textProvider = CLKSimpleTextProvider(text: "💧")
            //add tint color here
            let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
            handler(entry)
        default:
            handler(nil)
        }
    }
    
    // place logic to display water level here
    // use placeholder for now
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        let percentOfWaterGoal = 0.5
        let fillFraction = Float(percentOfWaterGoal)
        let displayPercentOfGoal = "50%"
        let preferredUnit = PreferredUnit(rawValue: UserDefaults.standard.integer(forKey: "Hydrate_preferredUnit"))
        let displayVolume: String
        if preferredUnit == PreferredUnit.fluidOunces {
            displayVolume = "50 Oz"
        } else {
            displayVolume = "1.5 L"
        }
        
        switch complication.family {
        // graphic Circular
        case .graphicCircular:
            let template = CLKComplicationTemplateGraphicCircularClosedGaugeText()
            template.centerTextProvider = CLKSimpleTextProvider(text: "💧")
            template.gaugeProvider = CLKSimpleGaugeProvider(style: .fill, gaugeColor: #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), fillFraction: fillFraction)
            handler(template)
        // graphic corner
        case .graphicCorner:
            let template = CLKComplicationTemplateGraphicCornerStackText()
            template.innerTextProvider = CLKSimpleTextProvider(text: "WATER: \(displayPercentOfGoal)")
            // add tint color here
            template.outerTextProvider = CLKSimpleTextProvider(text: "\(displayVolume)")
            // add tint color for outer text here
            handler(template)
        // graphic bezel
        case .graphicBezel:
            let template = CLKComplicationTemplateGraphicBezelCircularText()
            let circularTemplate = CLKComplicationTemplateGraphicCircularClosedGaugeText()
            circularTemplate.centerTextProvider = CLKSimpleTextProvider(text: "💧")
            circularTemplate.gaugeProvider = CLKSimpleGaugeProvider(style: .fill, gaugeColor: #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), fillFraction: fillFraction)
            template.circularTemplate = circularTemplate
            template.textProvider = CLKSimpleTextProvider(text: "Water \(displayVolume) - \(displayPercentOfGoal)")
            handler(template)
        // circular small
        case .circularSmall:
            let template = CLKComplicationTemplateCircularSmallRingText()
            template.textProvider = CLKSimpleTextProvider(text: "💧")
            template.fillFraction = fillFraction
            template.ringStyle = .closed
            //add tint color here
            handler(template)
        //modular small
        case .modularSmall:
            let template = CLKComplicationTemplateModularSmallRingText()
            template.fillFraction = fillFraction
            template.textProvider = CLKSimpleTextProvider(text: "💧")
            //add tint color here
            handler(template)
        default:
            handler(nil)
        }
        
    }
    

}
