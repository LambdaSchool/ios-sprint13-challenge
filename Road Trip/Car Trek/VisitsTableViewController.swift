//
//  VisitsTableViewController.swift
//  Road Trip
//
//  Created by Christy Hicks on 5/17/20.
//  Copyright © 2020 Knight Night. All rights reserved.
//

import UIKit

class VisitsTableViewController: UITableViewController, VisitDelegate {
    // MARK: - Properties
    var visits: [Visit] = []
    var visit: Visit? {
        guard let indexPath = tableView.indexPathForSelectedRow else { return nil }
        let visit = visits[indexPath.row]
        return visit
    }
    
    // MARK: - Views
    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
        tableView.delegate = self
    }
    
    func updateViews() {
       
        tableView.reloadData()
    }

    // MARK: - Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visits.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "visitCell", for: indexPath)
        
        let displayedVisit = visits[indexPath.row]
        cell.textLabel?.text = displayedVisit.name
        print("Added \(visit?.name) to TVC")

        return cell
    }
    
    
    
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

     func updateTable(visit: Visit) {
        visits.append(visit)
        tableView.reloadData()
     }

    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "viewVisitSegue" {
            let visitVC = segue.destination as! VisitDetailViewController
            visitVC.visitDelegate = self
            
            visitVC.visit = self.visit
            
        } else if segue.identifier == "addVisitSegue" {
           let addVC = segue.destination as! VisitDetailViewController
           addVC.visitDelegate = self
        }
    }
}
