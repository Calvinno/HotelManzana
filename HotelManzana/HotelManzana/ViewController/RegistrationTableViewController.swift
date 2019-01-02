//
//  RegistrationTableViewController.swift
//  HotelManzana
//
//  Created by Calvin Cantin on 2018-12-22.
//  Copyright © 2018 Calvin Cantin. All rights reserved.
//

import UIKit

class RegistrationTableViewController: UITableViewController {
    
    var registrations:[Registration] = []
    var selectedRegistrationIndexPath:IndexPath?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    @IBAction func unwindFromAddRegistration(unwindSegue: UIStoryboardSegue)
    {
        guard let addRegistrationViewController = unwindSegue.source as? AddRegistrationTableViewController,
        let registration = addRegistrationViewController.registration else {return}

        registrations.append(registration)
        tableView.reloadData()
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return registrations.count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegistrationCell", for: indexPath)
        
        let dateFormater = DateFormatter()
        dateFormater.dateStyle = .short
        let registration = registrations[indexPath.row]
        let fullName = "\(registration.firstName) \(registration.lastName)"
        let checkInDate = dateFormater.string(from: registration.checkInDate)
        let checkOutDate = dateFormater.string(from: registration.checkOutDate)
        
        cell.textLabel?.text = fullName
        cell.detailTextLabel?.text = "\(checkInDate) \\ \(checkOutDate)"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        selectedRegistrationIndexPath = indexPath
        performSegue(withIdentifier: "RegistrationDetailSegue", sender: nil)
        
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RegistrationDetailSegue"
        {
            if let indexPath = selectedRegistrationIndexPath
            {
                let registration = registrations[indexPath.row]
                let navigationController = segue.destination as! UINavigationController
                let addRegistrationVC = navigationController.topViewController as! AddRegistrationTableViewController
                
                addRegistrationVC.previousRegistration = registration
                

            }
        }
    }

}
