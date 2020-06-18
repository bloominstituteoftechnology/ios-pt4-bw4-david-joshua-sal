//
//  AddWaterInputInterfaceController.swift
//  Hydrate
//
//  Created by Sal B Amer on 6/18/20.
//  Copyright © 2020 Hydrate. All rights reserved.
//

import WatchKit
import Foundation


class AddWaterInputInterfaceController: WKInterfaceController {
    
    //MARK: IBOUTLETS
    
    @IBOutlet weak var singleCupButton: WKInterfaceButton!
    
    @IBOutlet weak var twoCupButton: WKInterfaceButton!
    

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

    //MARK IBActions
    
    @IBAction func oneCupBtnPressed() {
    }
    
    @IBAction func twoCupBtnPressed() {
    }
    
    
    
    
}
