//
//  UserSettings.swift
//  Hydrate
//
//  Created by Joshua Rutkowski on 6/24/20.
//  Copyright © 2020 Hydrate. All rights reserved.
//

import Foundation
import Combine

 class UserSettings: ObservableObject {

     @Published var recieveNotifications: Bool {
        didSet {
            UserDefaults.standard.set(recieveNotifications, forKey: "isEnabledLocalNotifications")
            print(recieveNotifications)
        }
    }

     @Published var enableAppSounds: Bool {
        didSet {
            UserDefaults.standard.set(enableAppSounds, forKey: "isEnabledSounds")
        }
    }

     @Published var enableHapticFeedback: Bool {
        didSet {
            UserDefaults.standard.set(enableHapticFeedback, forKey: "isEnabledHapticFeedback")
        }
    }

     @Published var addToHealthApp: Bool {
        didSet {
            UserDefaults.standard.set(addToHealthApp, forKey: "isAddedToHealthApp")
        }
    }

     init(){
        self.recieveNotifications = UserDefaults.standard.objectIsForced(forKey: "isEnabledLocalNotifications") as? Bool ?? false

         self.enableAppSounds = UserDefaults.standard.objectIsForced(forKey: "isEnabledLocalNotifications") as? Bool ?? true

         self.enableHapticFeedback = UserDefaults.standard.objectIsForced(forKey: "isEnabledLocalNotifications") as? Bool ?? true

         self.addToHealthApp = UserDefaults.standard.objectIsForced(forKey: "isEnabledLocalNotifications") as? Bool ?? false
    }

 }
