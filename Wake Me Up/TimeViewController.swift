//
//  TimeViewController.swift
//  Wake Me Up
//
//  Created by Andrew Petrosky on 4/9/17.
//  Copyright © 2017 edu.upenn.seas.cis195. All rights reserved.
//

import UIKit

class TimeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var timePicker: UIDatePicker!
    var detailsController : DetailTableViewController!
    @IBOutlet weak var repeatTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        repeatTable.dataSource = self
        repeatTable.delegate = self
        let timeArray = detailsController.alarmTime.text?.components(separatedBy: ", ")
        if timeArray?.count == 2 {
            let repeats = timeArray?[1]
            repeatTable.reloadData()
            if repeats!.contains("M") {
                let cell = self.repeatTable.cellForRow(at: IndexPath(row: 0, section: 0))
                cell?.accessoryType = .checkmark
            }
            if repeats!.contains("T") {
                let cell = self.repeatTable.cellForRow(at: IndexPath(row: 1, section: 0))
                cell?.accessoryType = .checkmark
            }
            if repeats!.contains("W") {
                let cell = self.repeatTable.cellForRow(at: IndexPath(row: 2, section: 0))
                cell?.accessoryType = .checkmark
            }
            if repeats!.contains("R") {
                let cell = self.repeatTable.cellForRow(at: IndexPath(row: 3, section: 0))
                cell?.accessoryType = .checkmark
            }
            if repeats!.contains("F") {
                let cell = self.repeatTable.cellForRow(at: IndexPath(row: 4, section: 0))
                cell?.accessoryType = .checkmark
            }
            if repeats!.contains("Sat") {
                let cell = self.repeatTable.cellForRow(at: IndexPath(row: 5, section: 0))
                cell?.accessoryType = .checkmark
            }
            if repeats!.contains("Sun") {
                let cell = self.repeatTable.cellForRow(at: IndexPath(row: 6, section: 0))
                cell?.accessoryType = .checkmark
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func doneSelectingTime(_ sender: Any) {
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = DateFormatter.Style.short
        let time = timeFormatter.string(from: timePicker.date)
        let repeats = getRepeats()
        detailsController.alarmTime.text = time + repeats
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func getRepeats() -> String {
        var repeats = ""
        for r in 0...6 {
            let cell = self.repeatTable.cellForRow(at: IndexPath(row: r, section: 0))
            if cell?.accessoryType == .checkmark {
                if r == 0 {
                    repeats = repeats + "M"
                } else if r == 1 {
                    repeats = repeats + "T"
                } else if r == 2 {
                    repeats = repeats + "W"
                } else if r == 3 {
                    repeats = repeats + "R"
                } else if r == 4 {
                    repeats = repeats + "F"
                } else if r == 5 {
                    repeats = repeats + "Sat"
                } else {
                    repeats = repeats + "Sun"
                }
            }
        }
        if repeats != "" {
            repeats = ", " + repeats
        }
        return repeats
    }

    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repeatCell", for: indexPath)
        let r = indexPath.row
        if r == 0 {
            cell.textLabel?.text = "Monday"
        } else if r == 1 {
            cell.textLabel?.text = "Tuesday"
        } else if r == 2 {
            cell.textLabel?.text = "Wednesday"
        } else if r == 3 {
            cell.textLabel?.text = "Thursday"
        } else if r == 4 {
            cell.textLabel?.text = "Friday"
        } else if r == 5 {
            cell.textLabel?.text = "Saturday"
        } else {
            cell.textLabel?.text = "Sunday"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.isSelected = false
        if cell?.accessoryType == .checkmark {
            cell?.accessoryType = .none
        } else {
            cell?.accessoryType = .checkmark
        }
    }
}
