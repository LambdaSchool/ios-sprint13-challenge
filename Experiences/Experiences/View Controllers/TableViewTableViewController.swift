//
//  TableViewTableViewController.swift
//  Experiences
//
//  Created by Brandi Bailey on 1/17/20.
//  Copyright © 2020 Brandi Bailey. All rights reserved.
//

import UIKit
import CoreData

class TableViewTableViewController: UITableViewController {
    
    var experience: Experience?
    var experiences: [Experience] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchExperiences()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return experiences.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExperienceCell", for: indexPath)

        let experience = experiences[indexPath.row]
        cell.textLabel?.text = experience.title

        return cell
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func fetchExperiences() {
        
        let fetchRequest: NSFetchRequest<Experience> = Experience.fetchRequest()
        do {
            experiences = try CoreDataStack.context.fetch(fetchRequest)
            print(experiences)
        } catch {
            print(error)
        }
        
    }

}
