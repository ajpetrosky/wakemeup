//
//  NewAlarmViewController.swift
//  Wake Me Up
//
//  Created by Andrew Petrosky on 4/8/17.
//  Copyright © 2017 edu.upenn.seas.cis195. All rights reserved.
//

import UIKit

class NewAlarmViewController: UIViewController {
    
    private var embeddedDetailViewController : DetailTableViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func saveAlarm(_ sender: Any) {
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let id = segue.identifier
        if id == "detailsSegue" {
            embeddedDetailViewController = segue.destination as! DetailTableViewController
            embeddedDetailViewController.parentController = self
        } else if id == "selectContactSegue" {
            let dest = segue.destination as! ContactsTableViewController
            dest.detailsController = self.embeddedDetailViewController
        } else if id == "selectTimeSegue" {
            let dest = segue.destination as! TimeViewController
            dest.detailsController = self.embeddedDetailViewController
        }else if id == "selectSoundSegue" {
            let dest = segue.destination as! SoundViewController
            dest.detailsController = self.embeddedDetailViewController
        }
    }

}
