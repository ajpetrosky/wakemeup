//
//  NewAlarmViewController.swift
//  Wake Me Up
//
//  Created by Andrew Petrosky on 4/8/17.
//  Copyright © 2017 edu.upenn.seas.cis195. All rights reserved.
//

import UIKit
import CoreData

class NewAlarmViewController: UIViewController {
    
    private var embeddedDetailViewController : DetailTableViewController!
    var rootController : AlarmsTableViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        if !self.rootController.newAlarm {
            let alarm = self.rootController.alarms?[self.rootController.curAlarm]
            embeddedDetailViewController.alarmName.text = alarm?.value(forKey: "name") as? String
            let time = alarm?.value(forKey: "time") as! String
            let repeats = alarm?.value(forKey: "timeRepeat") as? String
            if let r = repeats {
                if r == "" {
                    embeddedDetailViewController.alarmTime.text = time
                } else {
                    embeddedDetailViewController.alarmTime.text = time + ", " + r
                }
            } else {
                embeddedDetailViewController.alarmTime.text = time
            }
            embeddedDetailViewController.alarmSnooze.isOn = (alarm?.value(forKey: "snooze") as? Bool)!
            embeddedDetailViewController.alarmSound.text = alarm?.value(forKey: "sound") as? String
            embeddedDetailViewController.alarmContact.text = alarm?.value(forKey: "textContact") as? String
            embeddedDetailViewController.alarmTextTime.text = alarm?.value(forKey: "textAfter") as? String
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func saveAlarm(_ sender: Any) {
        if embeddedDetailViewController.alarmName.text == "" || embeddedDetailViewController.alarmTime.text == "" {
            showAlert()
            return
        }
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let managedContext = appDelegate.persistentContainer.viewContext
            if self.rootController.newAlarm {
                let entity = NSEntityDescription.entity(forEntityName: "Alarm", in: managedContext)!
                var alarm = NSManagedObject(entity: entity, insertInto: managedContext)
                alarm = setUpAlarm(alarm: alarm)
                try? managedContext.save()
                self.rootController.alarms?.append(alarm)
                self.rootController.tableView.reloadData()
            } else {
                var alarm = self.rootController.alarms?[self.rootController.curAlarm]
                self.rootController.alarms?.remove(at: self.rootController.curAlarm)
                managedContext.delete(alarm!)
                let entity = NSEntityDescription.entity(forEntityName: "Alarm", in: managedContext)!
                alarm = NSManagedObject(entity: entity, insertInto: managedContext)
                alarm = setUpAlarm(alarm: alarm!)
                try? managedContext.save()
                self.rootController.alarms?.append(alarm!)
                self.rootController.tableView.reloadData()
            }
        } else {
            return
        }
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func setUpAlarm(alarm : NSManagedObject) -> NSManagedObject {
        alarm.setValue(embeddedDetailViewController.alarmName.text!, forKeyPath: "name")
        if let number = embeddedDetailViewController.contactNumber {
            alarm.setValue(number, forKeyPath: "contactNumber")
            alarm.setValue(embeddedDetailViewController.alarmContact.text!, forKeyPath: "textContact")
        } else {
            alarm.setValue("", forKeyPath: "contactNumber")
            alarm.setValue("None", forKeyPath: "textContact")
        }
        alarm.setValue(embeddedDetailViewController.alarmSound.text!, forKeyPath: "sound")
        alarm.setValue(embeddedDetailViewController.alarmTextTime.text!, forKeyPath: "textAfter")
        var timeArray = embeddedDetailViewController.alarmTime.text!.components(separatedBy: ", ")
        let time = timeArray[0]
        alarm.setValue(time, forKeyPath: "time")
        if timeArray.count == 2 {
            let repeats = timeArray[1]
            alarm.setValue(repeats, forKeyPath: "timeRepeat")
        } else {
            alarm.setValue("", forKeyPath: "timeRepeat")
        }
        alarm.setValue(embeddedDetailViewController.alarmSnooze.isOn, forKeyPath: "snooze")
        alarm.setValue(true, forKeyPath: "enabled")
        return alarm
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Incomplete", message: "Either the name or time of the alarm has not been set", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
