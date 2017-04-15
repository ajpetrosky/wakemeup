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
        let snooze = alarm.value(forKey: "snooze") as! Bool
        if snooze {
            content.categoryIdentifier = "SNOOZABLE"
        } else {
            content.categoryIdentifier = "GENERAL"
        }
        content.title = NSString.localizedUserNotificationString(forKey: name, arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "Alarm for " + timeStr + ". Open this notification to turn off.", arguments: nil)
        let days = ["Sun", "M", "T", "W", "R", "F", "Sat"]
        for i in 1...7 {
            if repeats == "" {
                requestAlarm(minute: minute!, hour: hour!, content: content, weekday: 0, alarm: alarm)
                break
            }
            let day = days[i-1]
            if !repeats.contains(day) { continue }
            requestAlarm(minute: minute!, hour: hour!, content: content, weekday: i, alarm: alarm)
        }
        
    }
    
    static func disableAlarmNotificationsFor(alarm : NSManagedObject) {
        let repeatsOpt = (alarm.value(forKeyPath: "timeRepeat") as? String)
        var repeats : String
        if let r = repeatsOpt {
            repeats = r
        } else {
            repeats = ""
        }
        var removals : [String] = []
        let center = UNUserNotificationCenter.current()
        let days = ["Sun", "M", "T", "W", "R", "F", "Sat"]
        for i in 1...7 {
            if repeats == "" {
                removals.append(alarm.objectID.uriRepresentation().absoluteString + String(0))
                break
            }
            let day = days[i-1]
            if !repeats.contains(day) { continue }
            removals.append(alarm.objectID.uriRepresentation().absoluteString + String(i))
        }
        center.removePendingNotificationRequests(withIdentifiers: removals)
    }
    
    static func setSnoozeNotification(alarm : NSManagedObject) {
        let name = "Snoozed " + (alarm.value(forKey: "name") as! String)
        let timeStr = alarm.value(forKey: "time") as! String
        let content = UNMutableNotificationContent()
        content.categoryIdentifier = "SNOOZABLE"
        content.title = NSString.localizedUserNotificationString(forKey: name, arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "Alarm for " + timeStr + ". Open this notification to turn off.", arguments: nil)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 540, repeats: false)
        let request = UNNotificationRequest(identifier: alarm.objectID.uriRepresentation().absoluteString + "snooze", content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error : Error?) in
            if let theError = error {
                print(theError.localizedDescription)
            }
        }
    }
    
    static func checkAwakeNotification(time : Double) {
        let content = UNMutableNotificationContent()
        content.categoryIdentifier = "GENERAL"
        content.title = NSString.localizedUserNotificationString(forKey: "Awake?", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "Are you awake? Open this notification to confirm.", arguments: nil)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: time, repeats: false)
        let request = UNNotificationRequest(identifier: "check", content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error : Error?) in
            if let theError = error {
                print(theError.localizedDescription)
            }
        }
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
        let request = UNNotificationRequest(identifier: alarm.objectID.uriRepresentation().absoluteString + String(weekday), content: content,   trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error : Error?) in
            if let theError = error {
                print(theError.localizedDescription)
            }
        }
    }
    
}
