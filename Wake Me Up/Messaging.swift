//
//  Messaging.swift
//  Wake Me Up
//
//  Created by Andrew Petrosky on 4/10/17.
//  Copyright © 2017 edu.upenn.seas.cis195. All rights reserved.
//

import Foundation
import Alamofire
import CoreData

class Messaging {
    
    static func queueText(contactName : String, contactNumber : String) {
        let user = UIDevice.current.name.components(separatedBy: "'")[0]
        let body = "Hi " + contactName + "! " + user + " might have overslept, do you want to make sure they're awake? Give them a call, or respond to this message with 'Y' to set their alarm again."
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let managedContext = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Text", in: managedContext)!
            let text = NSManagedObject(entity: entity, insertInto: managedContext)
            text.setValue(contactNumber, forKeyPath: "to")
            text.setValue(body, forKeyPath: "body")
            try? managedContext.save()
        }
    }
    
    static func dequeueText() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Text")
            do {
                let texts = try managedContext.fetch(fetchRequest)
                if texts.count > 0 {
                    managedContext.delete(texts[0])
                }
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
    
    static func sendQueuedText() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Text")
            do {
                let texts = try managedContext.fetch(fetchRequest)
                if texts.count == 1 {
                    let text = texts[0]
                    let to = text.value(forKeyPath: "to") as! String
                    let body = text.value(forKeyPath: "body") as! String
                    sendText(to: to, body: body)
                }
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
    
    private static func sendText(to : String, body : String) {
        let headers = ["Content-Type": "application/x-www-form-urlencoded"]
        let parameters: Parameters = ["To": to, "Body": body]
        Alamofire.request("https://wakemeupalarm.herokuapp.com/sms/", method: .post, parameters: parameters, headers: headers).response { response in
            print(response)
        }
    }
    
}
