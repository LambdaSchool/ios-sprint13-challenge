//
//  ExperiencesTableViewController.swift
//  ExperiencesWorkingDraft
//
//  Created by Cody Morley on 7/10/20.
//  Copyright © 2020 Cody Morley. All rights reserved.
//

import UIKit
//TODO: Need to write UITableViewCell or use default??
//TODO: Wire in Cell
//TODO: Set up tableview to display contents of elements in usedefaults
//TODO: Wire segue to pass experience via dependency injection to detail view

class ExperiencesTableViewController: UITableViewController {
    //MARK: - Properties -
    var experiences: [Experience]?
    
    
    //MARK: - Life Cycles -
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: - Table View Data Source -
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */


    /* //TODO: Stretch use table view to delete experiences from user defaults
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
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
