//
//  ExperiencesTableVC.swift
//  Experiences
//
//  Created by Cora Jacobson on 11/7/20.
//

import UIKit

class ExperiencesTableVC: UITableViewController {
    
    private lazy var dateFormatter: DateFormatter = {
        let result = DateFormatter()
        result.dateStyle = .medium
        result.timeStyle = .short
        return result
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ExperienceController.shared.experiences.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExperienceCell", for: indexPath)
        let experiences = ExperienceController.shared.experiences
        cell.textLabel?.text = experiences[indexPath.row].title
        let date = dateFormatter.string(from: experiences[indexPath.row].timestamp)
        cell.detailTextLabel?.text = date
        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailSegue",
           let indexPath = tableView.indexPathForSelectedRow {
            let detailVC = segue.destination as! DetailVC
            detailVC.experience = ExperienceController.shared.experiences[indexPath.row]
        } else if segue.identifier == "addExperienceSegue" {
            let addExpVC = segue.destination as! AddExperienceVC
            addExpVC.delegate = self
        }
    }

}

extension ExperiencesTableVC: AddExpDelegate {
    func addExperience() {
        tableView.reloadData()
    }
}
