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
        let days = ["M", "T", "W", "R", "F", "Sat", "Sun"]
        for i in 1...7 {
            if repeats == "" {
                requestAlarm(minute: minute!, hour: hour!, content: content, weekday: 0, alarm: alarm)
            }
            let day = days[i]
            if !repeats.contains(day) { continue }
            requestAlarm(minute: minute!, hour: hour!, content: content, weekday: i, alarm: alarm)
        }
        
    }
    
    static func disableAlarmNotificationsFor(alarm : NSManagedObject) {
        
    }
    
    private static func requestAlarm(minute : Int, hour : Int, content : UNNotificationContent, weekday : Int, alarm : NSManagedObject) {
        var dateInfo = DateComponents()
        dateInfo.minute = minute
        dateInfo.hour = hour
        var trigger : UNNotificationTrigger
        if weekday == 0 {
            trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: false)
        } else {
            dateInfo.weekday = weekday
            trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: true)
        }
        print(dateInfo.description)
        let request = UNNotificationRequest(identifier: alarm.objectID.description + String(weekday), content: content,   trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error : Error?) in
            if let theError = error {
                print(theError.localizedDescription)
            }
        }
    }
    
}
