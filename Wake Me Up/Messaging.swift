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
    
    static func sendText(contactName : String, contactNumber : String, delay : Double) {
        let user = UIDevice.current.name.components(separatedBy: "'")[0]
        let body = "Hi " + contactName + "! " + user + " might have overslept, do you want to make sure they're awake? Check in on them, or give them a call!"
        sendText(to: contactNumber, body: body, delay: String(Int(delay)))
    }
    
    static func cancelText() {
        let headers = ["Content-Type": "application/x-www-form-urlencoded"]
        let parameters: Parameters = ["sendText": "False"]
        
        Alamofire.request("https://polar-harbor-84800.herokuapp.com/set/", method: .post, parameters: parameters, headers: headers).response { response in
            print(response)
        }
    }
    
    private static func sendText(to : String, body : String, delay : String) {
        let headers = ["Content-Type": "application/x-www-form-urlencoded"]
        var parameters: Parameters = ["sendText": "True"]
        
        Alamofire.request("https://polar-harbor-84800.herokuapp.com/set/", method: .post, parameters: parameters, headers: headers).response { response in
            print(response)
        }
        
        parameters = ["To": to, "Body": body, "delay": delay]
        Alamofire.request("https://wakemeupalarm.herokuapp.com/sms/", method: .post, parameters: parameters, headers: headers).response { response in
            print(response)
        }
    }
    
}
