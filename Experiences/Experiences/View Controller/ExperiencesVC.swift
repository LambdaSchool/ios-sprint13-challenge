//
//  ExperiencesVC.swift
//  Experiences
//
//  Created by Norlan Tibanear on 11/15/20.
//

import UIKit
import MapKit

class ExperiencesVC: UITableViewController {
    
    // Outlets
    
    // Properties
//    let experiencesController = ExperienceController()
//    let experience: Experience? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()

    }//
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ExperienceController.shared.experiences.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let experiences = ExperienceController.shared.experiences
        cell.textLabel?.text = experiences[indexPath.row].title
        
        return cell
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetailVCSegue",
           let indexPath = tableView.indexPathForSelectedRow {
            let detailVC = segue.destination as! DetailsVC
            detailVC.experience = ExperienceController.shared.experiences[indexPath.row]
        } else if segue.identifier == "goToAddExperienceVCSegue" {
            let addExperienceVC = segue.destination as! AddExperience
            addExperienceVC.delegate = self
        }
    }

}//

extension ExperiencesVC: AddExperienceDelegate {
    func addNewExperience() {
        tableView.reloadData()
    }
}
