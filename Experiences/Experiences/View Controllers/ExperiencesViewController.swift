//
//  ExperiencesViewController.swift
//  Experiences
//
//  Created by Sal B Amer on 5/15/20.
//  Copyright © 2020 Sal B Amer. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class ExperiencesViewController: UIViewController {
  
  var experienceController: ExperienceController?
  let locationManager = CLLocationManager()
  var nameText = ""
  
//  var exp1 = experienceController?.createExperience(withTitle: "First Experience", image: nil, ofType: .audio, location: nil)
  
  //MARK: IBOutlets
  @IBOutlet weak var titleField: UITextField!
  @IBOutlet weak var tableView: UITableView!

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.reloadData()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    tableView.reloadData()
  }
  
  //MARK: Actions
  
  @IBAction func micBtnTapped(_ sender: Any) {
    self.nameText = titleField.text ?? ""
     performSegue(withIdentifier: "AudioSegue", sender: self)
  }
  
  @IBAction func cameraBtnTapped(_ sender: Any) {
    self.nameText = titleField.text ?? ""
       performSegue(withIdentifier: "PhotoSegue", sender: self)
  }
  
  @IBAction func videoBtnTapped(_ sender: Any) {
    self.nameText = titleField.text ?? ""
    performSegue(withIdentifier: "VideoSegue", sender: self)
  }
  
}

extension ExperiencesViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    experienceController?.experiences.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ExperiencesCell", for: indexPath)
  
    // configure cell
    cell.textLabel?.text = experienceController?.experiences[indexPath.row].title
    cell.detailTextLabel?.text = experienceController?.experiences[indexPath.row].mediaType.rawValue.capitalized ?? "Audio"
    return cell
  }
  
  
}
