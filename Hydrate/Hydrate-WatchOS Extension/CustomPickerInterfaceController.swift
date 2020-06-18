//
//  CustomPickerInterfaceController.swift
//  Hydrate-WatchOS Extension
//
//  Created by Sal B Amer on 6/18/20.
//  Copyright © 2020 Hydrate. All rights reserved.
//

import WatchKit
import Foundation
import HealthKit


class CustomPickerInterfaceController: WKInterfaceController {
    
    
    //MARK: Outlets
    @IBOutlet weak var customPicker: WKInterfacePicker!
    

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
    
    @IBAction func saveBtnWasPressed() {
       //TODO save to healthkit DataStore
        self.dismiss()
        
    }
    
    @IBAction func pickerValuesChanged(_ value: Int) {
    }
    
    
}
