//
//  ExperienceViewController.swift
//  Experiences-Sprint-Challenge
//
//  Created by Jonalynn Masters on 1/17/20.
//  Copyright © 2020 Jonalynn Masters. All rights reserved.
//

import UIKit
import CoreLocation

protocol ExperienceViewControllerDelegate {
    func mediaAdded(media: Media)
}

class ExperienceViewController: UIViewController {

// MARK: Properties
    var experienceController: ExperienceController?
    var experience: Experience?
    var coordinate: CLLocationCoordinate2D!
   
    var selectedMedia: Media?
    var addedMedia: [Media]?

// MARK: Outlets
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var descriptionTF: UITextField!
    @IBOutlet weak var tableView: UITableView!
  
    @IBOutlet weak var uiView: ContainerViewController!
    
// MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        if let experience = experience {
            self.coordinate = experience.coordinate
        }
        updateViews()
    }

    func updateViews() {
        guard let experience = experience else { return }
        tableView.reloadData()
        titleTF.text = experience.title
        descriptionTF.text = experience.subtitle
    }


    
// MARK: Actions
    @IBAction func addTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Add Media", message: "Picture? Video? Memo?", preferredStyle: .actionSheet)
        for type in MediaType.allCases {
            alert.addAction(UIAlertAction(title: type.rawValue, style: .default, handler: { (action) in
                DispatchQueue.main.async {
                    switch MediaType(rawValue: action.title!) {
                    case .audio:
                        self.performSegue(withIdentifier: "addAudioSegue", sender: self)
                    case .image:
                        self.performSegue(withIdentifier: "addImageSegue", sender: self)
                    case .video:
                        self.performSegue(withIdentifier: "addVideoSegue", sender: self)
                    default:
                        break
                    }
                }
            }))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        guard let title = titleTF.text,
            let description = descriptionTF.text,
            let coordinate = coordinate,
            let controller = experienceController else { return }
        if let experience = experience {
            experience.title = title
            experience.subtitle = description
            experience.updatedTimeStamp = Date()
            //This experience already exists in the array
            //controller.add(newExperience: experience)
        } else {
            controller.add(newExperience: Experience(title: title, subtitle: description, coordinate: coordinate))
        }
        navigationController?.popViewController(animated: true)
    }
    
 // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "addImageSegue":
            let vc = segue.destination as! ImageViewController
            vc.delegate = self
        case "showImageSegue":
            let vc = segue.destination as! ImageViewController
            vc.delegate = self
            vc.media = selectedMedia
        case "addVideoSegue":
            let vc = segue.destination as! VideoViewController
            vc.delegate = self
        case "showVideoSegue":
            let vc = segue.destination as! VideoViewController
            vc.delegate = self
            vc.media = selectedMedia
        case "addAudioSegue":
            let vc = segue.destination as! AudioViewController
            vc.delegate = self
        case "showAudioSegue":
            let vc = segue.destination as! AudioViewController
            vc.delegate = self
            vc.media = selectedMedia
        default:
            break
        }
    }
}

// MARK: - Extensions
extension ExperienceViewController: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return experience?.media.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MediaCell", for: indexPath)
        if let experience = experience {
            cell.textLabel?.text = experience.media[indexPath.row].mediaType.rawValue
            cell.detailTextLabel?.text = experience.media[indexPath.row].updatedDate?.formattedString() ?? experience.media[indexPath.row].createdDate.formattedString()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMedia = experience?.media[indexPath.row]
        switch selectedMedia?.mediaType {
        case .audio:
            self.performSegue(withIdentifier: "showAudioSegue", sender: self)
        case .image:
            self.performSegue(withIdentifier: "showImageSegue", sender: self)
        case .video:
            self.performSegue(withIdentifier: "showVideoSegue", sender: self)
        default:
            break
        }
    }
}

extension ExperienceViewController: ExperienceViewControllerDelegate {
    func mediaAdded(media: Media) {
        if let experience = experience {
            experience.addMedia(media: media)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } else {
            let title = self.titleTF.text ?? ""
            let subtitle = self.descriptionTF.text ?? ""
            let newExperience = Experience(title: title, subtitle: subtitle, coordinate: coordinate)
            experienceController?.add(newExperience: newExperience)
            experience = newExperience
            experience?.addMedia(media: media)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
//// Override to support editing the table view.
//func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//    if editingStyle == .delete {
//        
//    }
//}
