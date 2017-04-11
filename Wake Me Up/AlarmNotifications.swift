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
        let timeStr = alarm.value(forKey: "time") as! String
        let time = timeStr.components(separatedBy: ":")
        let repeatsOpt = (alarm.value(forKeyPath: "timeRepeat") as? String)
        var repeats : String
        if let r = repeatsOpt {
            repeats = r
        } else {
            repeats = ""
        }
        let name = alarm.value(forKey: "name") as! String
        
        var hour = Int(time[0])
        let minArray = time[1].components(separatedBy: " ")
        let minute = Int(minArray[0])
        if minArray[1] == "PM" {
            hour = hour! + 12
        }
        
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: name, arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "Alarm for " + timeStr, arguments: nil)
        var dateInfo = DateComponents()
        dateInfo.minute = minute!
        dateInfo.hour = hour!
        print(dateInfo.description)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: false)
        let request = UNNotificationRequest(identifier: alarm.objectID.description, content: content, trigger: trigger)
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
