//
//  ExperienceTableViewController.swift
//  Experiences
//
//  Created by Vincent Hoang on 7/10/20.
//  Copyright © 2020 Vincent Hoang. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ExperienceTableViewController: UITableViewController {
    
    // MARK: - Properties
    var experiences: [Experience] = [Experience]()
    
    let locationController = LocationController()
    
    // MARK: - View Initialization

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationController.getCurrentLocation()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return experiences.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as? ExperienceViewCell else {
            NSLog("The dequeued cell is not an instance of ExperienceViewCell")
            return UITableViewCell()
        }
        
        cell.experience = experiences[indexPath.row]

        return cell
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
        case "addSegue":
            NSLog("addSegue invoked")
            
            guard let addExperienceViewController = segue.destination as? AddViewController else {
                return
            }
            
            addExperienceViewController.locationController = locationController
            
        case "detailSegue":
            guard let mapViewController = segue.destination as? MapKitViewController else {
                return
            }
            
            guard let selectedExperience = sender as? ExperienceViewCell else {
                return
            }
            
            guard let indexPath = tableView.indexPath(for: selectedExperience) else {
                return
            }
            
            mapViewController.experience = experiences[indexPath.row]
            
        default:
            NSLog("Unexpected segue identifier or no segue available")
            return
        }

    }
    
    @IBAction func unwindToExperienceTable(_ unwindSegue: UIStoryboardSegue) {
        if let sourceViewController = unwindSegue.source as? AddViewController, let experience = sourceViewController.experience {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                experiences[selectedIndexPath.row] = experience
            } else {
                experiences.append(experience)
            }
            
            tableView.reloadData()
        }
    }
    
    // MARK: - Utility

}
