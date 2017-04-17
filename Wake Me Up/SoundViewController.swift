//
//  SoundViewController.swift
//  Wake Me Up
//
//  Created by Andrew Petrosky on 4/9/17.
//  Copyright © 2017 edu.upenn.seas.cis195. All rights reserved.
//

import UIKit
import AVFoundation

class SoundViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var soundPicker: UIPickerView!
    var detailsController : DetailTableViewController!
    let sounds = ["Classic"]
    var selected : String?
    var player : AVAudioPlayer?
    
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
        if let p = player {
            if p.isPlaying {
                p.stop()
                return
            }
        }
        
        let url = Bundle.main.url(forResource: "classic", withExtension: "caf")!
        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            
            player.prepareToPlay()
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func doneSelectingSound(_ sender: Any) {
        if selected == nil {
            selected = "Classic"
        }
        detailsController.alarmSound.text = selected
        _ = self.navigationController?.popViewController(animated: true)
    }
}
