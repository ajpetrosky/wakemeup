//
//  Messaging.swift
//  Wake Me Up
//
//  Created by Andrew Petrosky on 4/10/17.
//  Copyright © 2017 edu.upenn.seas.cis195. All rights reserved.
//

import Foundation
import Alamofire

class Messaging {
    
    static func sendText(contactName : String, contactNumber : String) {
        let headers = ["Content-Type": "application/x-www-form-urlencoded"]
        
        let user = UIDevice.current.name.components(separatedBy: "'")[0]
        let body = "Hi " + contactName + "! " + user + " might have overslept, do you want to make sure they're awake? Give them a call, or respond to this message with 'Y' to set their alarm again."
        
        let parameters: Parameters = [
            "To": contactNumber,
            "Body": body
        ]
        
        Alamofire.request("https://wakemeupalarm.herokuapp.com/sms/", method: .post, parameters: parameters, headers: headers).response { response in
            print(response)
        }
    }
    
}
