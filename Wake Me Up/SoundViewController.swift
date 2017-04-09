//
//  SoundViewController.swift
//  Wake Me Up
//
//  Created by Andrew Petrosky on 4/9/17.
//  Copyright © 2017 edu.upenn.seas.cis195. All rights reserved.
//

import UIKit

class SoundViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var soundPicker: UIPickerView!
    var detailsController : DetailTableViewController!
    let sounds = ["Classic", "Buzz", "Sunrise"]
    var selected : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        soundPicker.dataSource = self
        soundPicker.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Delegates and data sources
    
    //MARK: Data Sources
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sounds.count
    }
    
    //MARK: Delegates
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sounds[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selected = sounds[row]
    }
    
    @IBAction func playSound(_ sender: Any) {
    }
    
    @IBAction func doneSelectingSound(_ sender: Any) {
        detailsController.alarmSound.text = selected
        _ = self.navigationController?.popViewController(animated: true)
    }
}
