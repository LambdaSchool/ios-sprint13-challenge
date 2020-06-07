//
//  ExperiencesTableViewController.swift
//  Experiences
//
//  Created by Bradley Diroff on 6/6/20.
//  Copyright © 2020 Bradley Diroff. All rights reserved.
//

import UIKit

class ExperiencesTableViewController: UITableViewController {
        var experiences = [Experience]()

        override func viewDidLoad() {
            super.viewDidLoad()

            DispatchQueue.main.async {
                LocationService.sharedInstance.getOneTimeLocation()
            }
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ExperiencesTableViewCell else {return UITableViewCell()}

            let item = experiences[indexPath.row]
            cell.experience = item
            
            if item.picture == nil {
                cell.pictureView.isHidden = true
            }
            
            if item.audio == nil {
                cell.audioView.isHidden = true
            }

            return cell
        }
        
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var cellHeight: CGFloat = 350
        
        let item = experiences[indexPath.row]
        
        if item.audio == nil {
            cellHeight -= 70
        }
        
        if item.picture == nil {
            cellHeight -= 230
        }
        
        return cellHeight
    }
        
        // MARK: - Navigation

        // In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "addExperience" {
                guard let vc = segue.destination as? AudioRecorderPictureController else {return}
                vc.delegate = self
            }
            
            if segue.identifier == "showMap" {
                guard let vc = segue.destination as? ExperiencesMapViewController else {return}
                vc.experiences = self.experiences
            }
        }
    }

    extension ExperiencesTableViewController: AddItemDelegate {
        func itemWasAdded(_ item: Experience) {
            print("item added?")
            experiences.append(item)
            tableView.reloadData()
        }
    }
