//
//  AlarmsTableViewController.swift
//  Wake Me Up
//
//  Created by Andrew Petrosky on 4/8/17.
//  Copyright © 2017 edu.upenn.seas.cis195. All rights reserved.
//

import UIKit

class AlarmsTableViewController: UITableViewController {
    
    var newAlarm = true

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func addAlarm(_ sender: Any) {
        newAlarm = true
        self.performSegue(withIdentifier: "editAlarmSegue", sender: self)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        newAlarm = false
        self.performSegue(withIdentifier: "editAlarmSegue", sender: self)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editAlarmSegue" {
            let dest = segue.destination as! NewAlarmViewController
            if newAlarm {
                dest.navigationItem.title = "Add New Alarm"
            } else {
                dest.navigationItem.title = "Edit Alarm"
                // Supply selected alarms details to dest
            }
        }
    }

}
