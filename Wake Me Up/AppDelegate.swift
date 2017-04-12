//
//  AppDelegate.swift
//  Wake Me Up
//
//  Created by Andrew Petrosky on 4/8/17.
//  Copyright © 2017 edu.upenn.seas.cis195. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UINavigationBar.appearance().barTintColor = UIColor(red: 153/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0)
        UINavigationBar.appearance().isTranslucent = false
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        let snoozeAction = UNNotificationAction(identifier: "SNOOZE_ACTION",
                                                title: "Snooze",
                                                options: UNNotificationActionOptions(rawValue: 0))
        let genCategory = UNNotificationCategory(identifier: "SNOOZABLE",
                                                     actions: [],
                                                     intentIdentifiers: [],
                                                     options: .customDismissAction)
        let snoozeCategory = UNNotificationCategory(identifier: "GENERAL",
                                                 actions: [snoozeAction],
                                                 intentIdentifiers: [],
                                                 options: .customDismissAction)
        center.setNotificationCategories([genCategory, snoozeCategory])
        
        center.requestAuthorization(options: [.alert]) { (granted, error) in
            if let theError = error {
                print(theError.localizedDescription)
            }
        }
        return true
    }
    
    // MARK: - Notification center delegate
    
    // The method will be called on the delegate when the user responded to the notification by opening the application, dismissing the notification or choosing a UNNotificationAction. The delegate must be set before the application returns from applicationDidFinishLaunching:.
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Swift.Void) {
        let alarm = getAlarm(notification: response.notification)
        let action = response.actionIdentifier
        print(action)
        if action == UNNotificationDismissActionIdentifier || action == UNNotificationDefaultActionIdentifier {
            let repeats = alarm.value(forKeyPath: "timeRepeat") as! String
            if repeats == "" {
                alarm.setValue(false, forKey: "enabled")
                saveContext()
            }
            
            let contactName = alarm.value(forKeyPath: "textContact") as! String
            if contactName !=  "None" {
                var contactNumber = alarm.value(forKeyPath: "contactNumber") as! String
                contactNumber = "+1" + contactNumber.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: "-", with: "").replacingOccurrences(of: "+1", with: "")
                let textAfter = Double(alarm.value(forKeyPath: "textAfter") as! String)
                DispatchQueue.main.asyncAfter(deadline: .now() + textAfter!) {
                    Messaging.sendText(contactName: contactName, contactNumber: contactNumber)
                }
            }
        } else if action == "SNOOZE_ACTION" {
            AlarmNotifications.setSnoozeNotification(alarm: alarm)
        }
        completionHandler()
    }
    
    func getAlarm(notification : UNNotification) -> NSManagedObject {
        let managedContext = self.persistentContainer.viewContext
        let startIndex = notification.request.identifier.startIndex
        let index = notification.request.identifier.index(startIndex, offsetBy: notification.request.identifier.characters.count - 1)
        let alarmId = notification.request.identifier.substring(to: index)
        let id = persistentContainer.persistentStoreCoordinator.managedObjectID(forURIRepresentation: URL(string: alarmId)!)
        let alarm = managedContext.object(with: id!)
        
        return alarm
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Wake_Me_Up")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

