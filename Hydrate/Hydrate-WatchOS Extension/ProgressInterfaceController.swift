//
//  ProgressInterfaceController.swift
//  Hydrate-WatchOS Extension
//
//  Created by Sal B Amer on 6/24/20.
//  Copyright © 2020 Hydrate. All rights reserved.
//

import WatchKit
import Foundation


class ProgressInterfaceController: WKInterfaceController {

        //MARK: Outlets
        
        @IBOutlet var progressGroup: WKInterfaceGroup!
        @IBOutlet var picker: WKInterfacePicker!
        
        override func awake(withContext context: Any?) {
            super.awake(withContext: context)
            
            var images: [UIImage]! = []
            var pickerItems: [WKPickerItem]! = []
            for i in 0...100 {
                let name = "activity-\(i)"
                images.append(UIImage(named: name)!)
                
                let pickerItem = WKPickerItem()
                pickerItem.title = "\(i)%"
                pickerItems.append(pickerItem)
            }
            
            let progressImages = UIImage.animatedImage(with: images, duration: 0.0)
            progressGroup.setBackgroundImage(progressImages)
            picker.setCoordinatedAnimations([progressGroup])
            picker.setItems(pickerItems)
        }
        
        //MARK: Actions
        @IBAction func addDrinkBtnWasPressed() {
        }
    }
