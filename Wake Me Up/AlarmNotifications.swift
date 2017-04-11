//
//  AlarmNotifications.swift
//  Wake Me Up
//
//  Created by Andrew Petrosky on 4/10/17.
//  Copyright © 2017 edu.upenn.seas.cis195. All rights reserved.
//

import Foundation
import UserNotifications
import CoreData
import UIKit

class AlarmNotifications {
    
    static func enableAlarmNotificationsFor(alarm : NSManagedObject) {
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: "Wake up!", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "Rise and shine! It's morning time!", arguments: nil)
        var dateInfo = DateComponents()
        dateInfo.minute = 12
        dateInfo.hour = 14
        print(dateInfo.description)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: false)
        let request = UNNotificationRequest(identifier: "Wake up!", content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error : Error?) in
            if let theError = error {
                print(theError.localizedDescription)
            }
        }
        
    }
    
    static func disableAlarmNotificationsFor(alarm : NSManagedObject) {
        
    }
    
}
