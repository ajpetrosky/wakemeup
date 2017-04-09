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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playSound(_ sender: Any) {
    }
    
    @IBAction func doneSelectingSound(_ sender: Any) {
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
