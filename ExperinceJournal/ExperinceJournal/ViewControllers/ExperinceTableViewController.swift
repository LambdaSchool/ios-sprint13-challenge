//
//  ExperinceTableViewController.swift
//  ExperinceJournal
//
//  Created by Lambda_School_Loaner_218 on 2/16/20.
//  Copyright © 2020 Lambda_School_Loaner_218. All rights reserved.
//

import UIKit

class ExperinceTableViewController: UITableViewController {

    

        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            tableView.reloadData()
        }

        override func viewDidLoad() {
            super.viewDidLoad()
            tableView.reloadData()
        }

        @IBAction func addEntryTapped(_ sender: Any) {
            addEntry()
        }

        private func addEntry() {
            let alert = UIAlertController(title: "New Post", message: "Which kind of post do you want to create?", preferredStyle: .actionSheet)

            let imagePostAction = UIAlertAction(title: "Image", style: .default) { (_) in
                self.performSegue(withIdentifier: "ShowImageSegue", sender: nil)
            }

            let audioPostAction = UIAlertAction(title: "Audio", style: .default) { (_) in
                self.performSegue(withIdentifier: "ShowAudioSegue", sender: nil)
            }

            let videoPostAction = UIAlertAction(title: "Video", style: .default) { (_) in
                self.performSegue(withIdentifier: "ShowVideoSegue", sender: nil)
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
            return EntryController.shared.entries.count
        }

        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "JournalCell", for: indexPath)

           
            cell.textLabel?.text = EntryController.shared.entries[indexPath.row].title
            cell.detailTextLabel?.text = EntryController.shared.entries[indexPath.row].mediaType.rawValue

            return cell
        }

        // MARK: - Navigation

       
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            switch segue.identifier {
            case "ShowImageSegue":
                if let destinationVC = segue.destination as? ImagePostViewController {
               
                    destinationVC.delegate = self as ImageViewControllerDelegate
                    
                }
            case "ShowAudioSegue":
                if let destinationVC = segue.destination as? AudioViewController {
                    
                    destinationVC.delegate = self as? AudioViewControllerDelegate
                }
            case "ShowVideoSegue":
                if let destinationVC = segue.destination as? VideoViewController {
                   
                    destinationVC.delegate = self as? VideoViewControllerDelegate
                }
            default:
                return
            }
        }
    }

    extension ExperinceTableViewController: ImageViewControllerDelegate, AudioViewControllerDelegate, VideoViewControllerDelegate {
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
