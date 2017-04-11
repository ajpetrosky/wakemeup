//
//  AlarmsTableViewController.swift
//  Wake Me Up
//
//  Created by Andrew Petrosky on 4/8/17.
//  Copyright © 2017 edu.upenn.seas.cis195. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class AlarmsTableViewController: UITableViewController {
    
    var newAlarm = true
    var curAlarm = 0;
    var alarms : [NSManagedObject]?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadAlarms()
    }
    
    func loadAlarms() {
        alarms = []
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Alarm")
            do {
                alarms = try managedContext.fetch(fetchRequest)
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        } else {
            return
        }
        self.tableView.reloadData()
    }
    
    @IBAction func toggleAlarm(_ sender: Any) {
        if let swit = sender as? UISwitch {
            if let superview = swit.superview {
                if let cell = superview.superview as? AlarmTableViewCell {
                    let indexPath = self.tableView.indexPath(for: cell)
                    let alarm = alarms?[(indexPath?.row)!]
                    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                        alarm?.setValue(swit.isOn, forKey: "enabled")
                        appDelegate.saveContext()
                    }
                }
            }
        }
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
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (alarms?.count)!
    }
    
    // MARK: - Table view delegate

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "alarmCell", for: indexPath) as! AlarmTableViewCell
        let alarm = alarms?[indexPath.row]
        let repeats = (alarm?.value(forKeyPath: "timeRepeat") as? String)
        if let r = repeats {
            if r == "" {
                cell.alarmName?.text = (alarm?.value(forKeyPath: "name") as? String)!
            } else {
                cell.alarmName?.text = (alarm?.value(forKeyPath: "name") as? String)! + ", " + r
            }
        } else {
            cell.alarmName?.text = (alarm?.value(forKeyPath: "name") as? String)!
        }
        cell.alarmContact?.text = alarm?.value(forKeyPath: "textContact") as? String
        cell.alarmTime?.text = alarm?.value(forKeyPath: "time") as? String
        cell.alarmEnable.isOn = (alarm?.value(forKeyPath: "enabled") as? Bool)!
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        newAlarm = false
        curAlarm = indexPath.row
        self.performSegue(withIdentifier: "editAlarmSegue", sender: self)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alarm = alarms?[indexPath.row]
            alarms?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                let managedContext = appDelegate.persistentContainer.viewContext
                managedContext.delete(alarm!)
                try? managedContext.save()
            }
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editAlarmSegue" {
            let dest = segue.destination as! NewAlarmViewController
            let backItem = UIBarButtonItem()
            backItem.title = "Cancel"
            navigationItem.backBarButtonItem = backItem
            dest.rootController = self
            if newAlarm {
                dest.navigationItem.title = "Add New Alarm"
            } else {
                dest.navigationItem.title = "Edit Alarm"
            }
        }
    }
}
