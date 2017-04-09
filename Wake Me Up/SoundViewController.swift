//
//  SoundViewController.swift
//  Wake Me Up
//
//  Created by Andrew Petrosky on 4/9/17.
//  Copyright © 2017 edu.upenn.seas.cis195. All rights reserved.
//

import UIKit

class SoundViewController: UIViewController {

    @IBOutlet weak var soundPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func playSound(_ sender: Any) {
    }
    
    @IBAction func doneSelectingSound(_ sender: Any) {
        
        _ = self.navigationController?.popViewController(animated: true)
    }
}
