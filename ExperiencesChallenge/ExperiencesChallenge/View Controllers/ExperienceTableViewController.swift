//
//  ExperienceTableViewController.swift
//  ExperiencesChallenge
//
//  Created by Ian French on 9/13/20.
//  Copyright © 2020 Ian French. All rights reserved.
//

import UIKit

class ExperienceTableViewController: UITableViewController {


    @IBOutlet weak var addExperienceButton: UIBarButtonItem!

    var experienceController: ExperienceController?

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func addExperienceButtonTapped(_ sender: UIBarButtonItem) {
        addExperience()
    }


    private func addExperience() {
        let alert = UIAlertController(title: "New Experience", message: "What kind of experience are you adding?", preferredStyle: .actionSheet)

        let addImageAction = UIAlertAction(title: "Image", style: .default) { (_) in
            self.performSegue(withIdentifier: "imageSegue", sender: nil)
        }

        let addAudioAction = UIAlertAction(title: "Audio", style: .default) { (_) in
            self.performSegue(withIdentifier: "audioSegue", sender: nil)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alert.addAction(addImageAction)
        alert.addAction(addAudioAction)
        alert.addAction(cancelAction)

        self.present(alert, animated: true, completion: nil)
    }

    // MARK: - Table view data source

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return experienceController?.experiences.count ?? 0
        }

        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExpCell", for: indexPath)

            cell.textLabel?.text = experienceController?.experiences[indexPath.row].title
            cell.detailTextLabel?.text = experienceController?.experiences[indexPath.row].mediaType.rawValue

            return cell
        }

        // MARK: - Navigation

        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            switch segue.identifier {
            case "imageSegue":
                if let destinationVC = segue.destination as? ImageViewController {
                    destinationVC.experienceController = self.experienceController
                    destinationVC.delegate = self
                }
            case "audioSegue":
                if let destinationVC = segue.destination as? AudioViewController {
                    destinationVC.experienceController = self.experienceController
                    destinationVC.delegate = self
                }

            default:
                return
            }
        }
    }

extension ExperienceTableViewController: ImageViewControllerDelegate, AudioViewControllerDelegate {

        func saveImageButtonTapped() {
            tableView.reloadData()
        }

        func saveAudioButtonTapped() {
            tableView.reloadData()
        }

    }
