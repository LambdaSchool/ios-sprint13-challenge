//
//  ExperiencesTableViewController.swift
//  Experiences
//
//  Created by Sal B Amer on 5/19/20.
//  Copyright © 2020 Sal B Amer. All rights reserved.
//

import UIKit

class ExperiencesTableViewController: UITableViewController {
  
  var experienceController: ExperienceController?

    override func viewDidLoad() {
      super.viewDidLoad()
      tableView.reloadData()
    }
  
  override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      tableView.reloadData()
  }
  
    // Outlets
  

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return experienceController?.experiences.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExperiencesCell", for: indexPath)

      cell.textLabel?.text = experienceController?.experiences[indexPath.row].title
      cell.detailTextLabel?.text = experienceController?.experiences[indexPath.row].mediaType.rawValue
      return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      switch segue.identifier {
      case "AudioSegue":
        if let destinationVC = segue.destination as? AudioViewController {
          destinationVC.experienceController = self.experienceController
          destinationVC.delegate = self
        }
      case "PhotoSegue":
        if let destinationVC = segue.destination as? ImagesViewController {
          destinationVC.experienceController = self.experienceController
          destinationVC.delegate = self
        }
      case "VideoSegue":
        if let destinationVC = segue.destination as? VideoViewController {
          destinationVC.experienceController = self.experienceController
          destinationVC.delegate = self
        }
      default:
        return
      }
    }
  
  func createExperience() {
    
    let alert = UIAlertController(title: "New Post", message: "Which kind of experience do you want to create?", preferredStyle: .actionSheet)

    let imagePost = UIAlertAction(title: "Photo", style: .default) { (_) in
        self.performSegue(withIdentifier: "PhotoSegue", sender: nil)
    }

    let audioPost = UIAlertAction(title: "Audio", style: .default) { (_) in
        self.performSegue(withIdentifier: "AudioSegue", sender: nil)
    }

    let videoPost = UIAlertAction(title: "Video", style: .default) { (_) in
        self.performSegue(withIdentifier: "VideoSegue", sender: nil)
    }

    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

    alert.addAction(imagePost)
    alert.addAction(audioPost)
    alert.addAction(videoPost)
    alert.addAction(cancelAction)

    self.present(alert, animated: true, completion: nil)
    
  }
  
  //IB Actions
  @IBAction func addExperienceButton(_ sender: Any) {
    createExperience()
  }
  
  
}


extension ExperiencesTableViewController: ImageViewControllerDelegate, AudioViewControllerDelegate, VideoViewControllerDelegate {
    func PhotoButtonWasTapped() {
        tableView.reloadData()
    }

  func AudioButtonWasTapped() {
        tableView.reloadData()
    }

    func videoButtonWasTapped() {
        tableView.reloadData()
    }


}
