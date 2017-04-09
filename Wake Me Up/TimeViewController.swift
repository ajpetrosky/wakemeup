//
//  TimeViewController.swift
//  Wake Me Up
//
//  Created by Andrew Petrosky on 4/9/17.
//  Copyright © 2017 edu.upenn.seas.cis195. All rights reserved.
//

import UIKit

class TimeViewController: UIViewController {

    @IBOutlet weak var timePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func doneSelectingTime(_ sender: Any) {
        
        _ = self.navigationController?.popViewController(animated: true)
    }

}
