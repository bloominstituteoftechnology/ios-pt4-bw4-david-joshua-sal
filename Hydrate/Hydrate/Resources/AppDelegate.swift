//
//  AppDelegate.swift
//  Hydrate
//
//  Created by Joshua Rutkowski on 6/16/20.
//  Copyright © 2020 Hydrate. All rights reserved.
//

import UIKit
import HealthKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let healthKitStore = HKHealthStore()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // add HealthKitSetup Helper to app startup.
        HealthKitSetupHelper().authorize { (authorized, error) in
            guard authorized else {
                let notAuthMessage = "Authorization to HealthKit Failed"
                if let error = error {
                    print("\(notAuthMessage) Because: \(error.localizedDescription)")
                } else {
                    print(notAuthMessage)
                }
                return
            }
            print("HealthKit Authorization Successful")
        }
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

