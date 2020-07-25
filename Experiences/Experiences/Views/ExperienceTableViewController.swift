//
//  ExperienceTableViewController.swift
//  Experiences
//
//  Created by Kevin Stewart on 7/17/20.
//  Copyright © 2020 Kevin Stewart. All rights reserved.
//

import UIKit
import MapKit

class Experience: NSObject {
    
    var name: String
    var url: URL
    
    init(name: String,
         url: URL) {
        self.name = name
        self.url = url
        
        super.init()
    }
}

class ExperienceController {
    var userLocation: CLLocationCoordinate2D?
    var experiences: [Experience] = []
}

class ExperienceTableViewController: UITableViewController {
    
    var experienceController = ExperienceController()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print(experienceController.experiences.count)
        return experienceController.experiences.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExperienceCell", for: indexPath)
        
        let experience = experienceController.experiences[indexPath.row]
        cell.textLabel?.text = experience.name
        cell.detailTextLabel?.text = "\(Date())"
        
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RecordingSegue" {
            guard let addRecordingVC = segue.destination as? RecordingViewController else { return }
            addRecordingVC.delegate = self
        } else if segue.identifier == "PhotoSegue" {
            guard let addPhotoVC = segue.destination as? PhotoViewController else { return }
            addPhotoVC.delegate = self
        } else if segue.identifier == "ExperienceMapSegue" {
            guard let experienceMapVC = segue.destination as? MapViewController else { return }
            experienceMapVC.experienceController = self.experienceController
        }
    }
}
extension ExperienceTableViewController: AddExperienceDelegate {
    func experienceWasAdded(experience: Experience) {
        experienceController.experiences.append(experience)
        tableView.reloadData()
    }
}
