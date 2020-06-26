//
//  LocalNotificationManager.swift
//  Hydrate
//
//  Created by Joshua Rutkowski on 6/24/20.
//  Copyright © 2020 Hydrate. All rights reserved.
//

import Foundation
import UserNotifications

struct Notification {
    var id: String
    var title: String
}

class LocalNotificationManager {
    var notifications = [Notification]()
    
    /// Requests permission for notifications
    /// - Returns:A request to grant permission
    func requestPermission() -> Void {
        UNUserNotificationCenter
            .current()
            .requestAuthorization(options: [.alert, .badge, .alert]) { granted, error in
                if granted == true && error == nil {
                    // We have permission!
                }
        }
    }
    
    /// Adds notification to scheduler.
    /// - Parameter title: Title of notification.
    /// - Returns: Notification
    func addNotification(title: String) -> Void {
        notifications.append(Notification(id: UUID().uuidString, title: title))
    }
    
    
    /// Schedules notifications
    /// - Returns: Schedules a notification after a specific time interval, which can be repeated. Sets a unique ID for each notification.
    func scheduleNotifications() -> Void {
        for notification in notifications {
            let center = UNUserNotificationCenter.current()
            let content = UNMutableNotificationContent()
            content.title = notification.title
            content.sound = UNNotificationSound.default
            
            var dateComponents = DateComponents()
            dateComponents.hour = 10
            dateComponents.minute = 30

//          let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)
            
            center.removeAllPendingNotificationRequests()

            UNUserNotificationCenter.current().add(request) { error in
                guard error == nil else { return }
                print("Scheduling notification with id: \(notification.id) with trigger: \(trigger)")
            }
        }
    }
    
    
    /// Asks for permission if permission was not already granted.
    /// - Returns: Requests permission if not already requested. If requested, then schedules the notification.
    func schedule() -> Void {
          UNUserNotificationCenter.current().getNotificationSettings { settings in
              switch settings.authorizationStatus {
              case .notDetermined:
                  self.requestPermission()
              case .authorized, .provisional:
                  self.scheduleNotifications()
              default:
                  break
              }
          }
      }
    
    
}

