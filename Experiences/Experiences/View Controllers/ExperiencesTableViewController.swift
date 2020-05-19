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

  
  //IB Actions
  
  @IBAction func recordAudioBtnPressed(_ sender: Any) {
    performSegue(withIdentifier: "AudioSegue", sender: nil)
  }
  
  @IBAction func takePhotoBtnPressed(_ sender: Any) {
  }
  
  @IBAction func takeVideoBtnPressed(_ sender: Any) {
  }
  
  @IBAction func showMapBtnPressed(_ sender: Any) {
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
