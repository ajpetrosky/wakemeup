//
//  ContactsTableViewController.swift
//  Wake Me Up
//
//  Created by Andrew Petrosky on 4/9/17.
//  Copyright © 2017 edu.upenn.seas.cis195. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

class ContactsTableViewController: UITableViewController {
    
    var detailsController : DetailTableViewController!
    
    var store : CNContactStore!
    var contacts : [CNContact]?

    override func viewDidLoad() {
        super.viewDidLoad()
        store = CNContactStore()
        contacts = []
        let authorizationStatus = CNContactStore.authorizationStatus(for: .contacts)
        
        switch authorizationStatus {
        case .authorized:
            var allContainers: [CNContainer] = []
            do {
                allContainers = try self.store.containers(matching: nil)
            } catch {
                print("Error fetching containers")
            }
            for container in allContainers {
                let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
                
                do {
                    var containerResults = try self.store.unifiedContacts(matching: fetchPredicate, keysToFetch: [CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactPhoneNumbersKey as CNKeyDescriptor])
                    var i = 0
                    while (i < containerResults.count) {
                        let contact = containerResults[i]
                        if contact.givenName == "" || contact.familyName == "" || contact.phoneNumbers.isEmpty {
                            containerResults.remove(at: i)
                            continue
                        }
                        i = i + 1
                    }
                    self.contacts?.append(contentsOf: containerResults)
                } catch {
                    print("Error fetching results for container")
                    _ = self.navigationController?.popViewController(animated: true)
                }
            }
            self.tableView.reloadData()
        case .notDetermined:
            self.store.requestAccess(for: .contacts, completionHandler: { (access, error) -> Void in
                if access {
                    var allContainers: [CNContainer] = []
                    do {
                        allContainers = try self.store.containers(matching: nil)
                    } catch {
                        print("Error fetching containers")
                    }
                    for container in allContainers {
                        let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
                        
                        do {
                            var containerResults = try self.store.unifiedContacts(matching: fetchPredicate, keysToFetch: [CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactPhoneNumbersKey as CNKeyDescriptor])
                            var i = 0
                            while (i < containerResults.count) {
                                let contact = containerResults[i]
                                if contact.givenName == "" || contact.familyName == "" || contact.phoneNumbers.isEmpty {
                                    containerResults.remove(at: i)
                                    continue
                                }
                                i = i + 1
                            }
                            self.contacts?.append(contentsOf: containerResults)
                        } catch {
                            print("Error fetching results for container")
                            _ = self.navigationController?.popViewController(animated: true)
                        }
                    }
                    self.tableView.reloadData()
                }
                else {
                    if authorizationStatus == .denied {
                        DispatchQueue.main.async(execute: { () -> Void in
                            let message = "\(error!.localizedDescription)\n\nPlease allow Wake Me Up to access your contacts through Settings."
                            self.showAlert(message: message)
                        })
                    }
                }
            })
        default:
            _ = self.navigationController?.popViewController(animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (contacts?.count)! + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath)
        if indexPath.row == 0 {
            cell.textLabel?.text = "None"
            cell.detailTextLabel?.text = ""
            return cell
        }
        let contact = contacts?[indexPath.row]
        if let firstName = contact?.givenName {
            cell.textLabel?.text = firstName
            if let lastName = contact?.familyName {
                cell.textLabel?.text = (cell.textLabel?.text)! + " " + lastName
            }
        }
        
        let numbers = contact?.phoneNumbers
        let number = ((numbers?.first?.value)! as CNPhoneNumber).stringValue
        cell.detailTextLabel?.text = number

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        self.detailsController.alarmContact.text = cell?.textLabel?.text
        self.detailsController.contactNumber = cell?.detailTextLabel?.text
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func showAlert(message : String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
