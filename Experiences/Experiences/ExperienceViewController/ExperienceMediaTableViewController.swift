//
//  ExperienceMediaTableViewController.swift
//  Experiences
//
//  Created by Shawn Gee on 5/8/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import UIKit

class ExperienceMediaTableViewController: UITableViewController {

    
    // MARK: - Public Properties
    
    var experience: Experience?
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Public Methods

    func refresh() {
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let experience = experience else { return 0 }
        switch section {
        case 0:
            return experience.audioClips.count
        case 1:
            return experience.videos.count
        case 2:
            return experience.photos.count
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return audioCell(forRowAt: indexPath)
        case 1:
            return videoCell(forRowAt: indexPath)
        case 2:
            return photoCell(forRowAt: indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    private func audioCell(forRowAt indexPath: IndexPath) -> AudioTableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AudioCell", for: indexPath) as? AudioTableViewCell else {
            fatalError("Unable to cast cell to type \(AudioTableViewCell.self)")
        }
        cell.url = experience?.audioClips[indexPath.row]
        return cell
    }
    
    private func videoCell(forRowAt indexPath: IndexPath) -> VideoTableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AudioCell", for: indexPath) as? VideoTableViewCell else {
            fatalError("Unable to cast cell to type \(VideoTableViewCell.self)")
        }
        return cell
    }
    
    private func photoCell(forRowAt indexPath: IndexPath) -> PhotoTableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AudioCell", for: indexPath) as? PhotoTableViewCell else {
            fatalError("Unable to cast cell to type \(PhotoTableViewCell.self)")
        }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
