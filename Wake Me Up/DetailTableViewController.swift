//
//  DetailTableViewController.swift
//  Wake Me Up
//
//  Created by Andrew Petrosky on 4/9/17.
//  Copyright © 2017 edu.upenn.seas.cis195. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

class DetailTableViewController: UITableViewController {
    
    var parentController : NewAlarmViewController!
    
    @IBOutlet weak var alarmName: UILabel!
    @IBOutlet weak var alarmTime: UILabel!
    @IBOutlet weak var alarmSnooze: UISwitch!
    @IBOutlet weak var alarmSound: UILabel!
    @IBOutlet weak var alarmContact: UILabel!
    @IBOutlet weak var alarmTextTime: UILabel!
    
    var contactNumber : String?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func textTimeIncremented(_ sender: Any, forEvent event: UIEvent) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let cell = tableView.cellForRow(at: indexPath)
        if row == 0 {
            cell?.isSelected = false
            changeNameAlert()
        } else if row == 1 {
            cell?.isSelected = false
            parentController.performSegue(withIdentifier: "selectTimeSegue", sender: parentController)
        } else if row == 3 {
            cell?.isSelected = false
            parentController.performSegue(withIdentifier: "selectSoundSegue", sender: parentController)
        } else if row == 4 {
            cell?.isSelected = false
            parentController.performSegue(withIdentifier: "selectContactSegue", sender: parentController)
        }
    }
    
    func changeNameAlert() {
        let alert = UIAlertController(title: "Change Alarm Name", message: "Enter new a new alarm name", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = ""
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            self.alarmName.text = textField?.text
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
