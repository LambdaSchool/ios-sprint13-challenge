//
//  JournalTableViewController.swift
//  Unit4-SprintChallenge1
//
//  Created by Lambda_School_Loaner_204 on 1/16/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class JournalTableViewController: UITableViewController {


    let entryController = EntryController()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func addEntryTapped(_ sender: Any) {
        addEntry()
    }

    private func addEntry() {
        let alert = UIAlertController(title: "New Post", message: "Which kind of post do you want to create?", preferredStyle: .actionSheet)

        let imagePostAction = UIAlertAction(title: "Image", style: .default) { (_) in
            self.performSegue(withIdentifier: "ModalImageSegue", sender: nil)
        }

        let audioPostAction = UIAlertAction(title: "Audio", style: .default) { (_) in
            self.performSegue(withIdentifier: "ModalAudioSegue", sender: nil)
        }

        let videoPostAction = UIAlertAction(title: "Video", style: .default) { (_) in
            self.performSegue(withIdentifier: "ModalVideoSegue", sender: nil)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alert.addAction(imagePostAction)
        alert.addAction(audioPostAction)
        alert.addAction(videoPostAction)
        alert.addAction(cancelAction)

        self.present(alert, animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return entryController.entries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JournalCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = entryController.entries[indexPath.row].title
        cell.detailTextLabel?.text = entryController.entries[indexPath.row].mediaType.rawValue

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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "ModalImageSegue":
            if let destinationVC = segue.destination as? ImageViewController {
                destinationVC.entryController = self.entryController
                destinationVC.delegate = self
            }
        case "ModalAudioSegue":
            if let destinationVC = segue.destination as? AudioViewController {
                destinationVC.entryController = self.entryController
                destinationVC.delegate = self
            }
        case "ModalVideoSegue":
            if let destinationVC = segue.destination as? VideoViewController {
                destinationVC.entryController = self.entryController
                destinationVC.delegate = self
            }
        default:
            return
        }
    }
}

extension JournalTableViewController: ImageViewControllerDelegate, AudioViewControllerDelegate, VideoViewControllerDelegate {
    func imagePostButtonWasTapped() {
        tableView.reloadData()
    }

    func audioPostButtonWasTapped() {
        tableView.reloadData()
    }

    func videoPostButtonWasTapped() {
        tableView.reloadData()
    }


}
