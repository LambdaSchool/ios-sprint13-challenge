//
//  ExperienceTableViewController.swift
//  Experiences
//
//  Created by Keri Levesque on 4/10/20.
//  Copyright © 2020 Keri Levesque. All rights reserved.
//

import UIKit
import CoreLocation

protocol ExperienceTableViewControllerDelegate {
    func mediaAdded(media: Media)
}

class ExperienceTableViewController: UITableViewController {

    //MARK: Properties
      var experienceController: ExperienceController?
      var experience: Experience?
      var coordinate: CLLocationCoordinate2D!
     
      var selectedMedia: Media?
      var addedMedia: [Media]?
    
    //MARK: Outlets
    @IBOutlet weak var titleTextField: UITextField!
    
    
    //MARK: Actions
    
    @IBAction func saveButton(_ sender: Any) {
        guard let title = titleTextField.text,
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
    
    
    
    @IBAction func addMedia(_ sender: UIButton) {
        let alert = UIAlertController(title: "Add Media", message: "Picture? Video? Memo?", preferredStyle: .actionSheet)
        for type in MediaType.allCases {
            alert.addAction(UIAlertAction(title: type.rawValue, style: .default, handler: { (action) in
                DispatchQueue.main.async {
                           switch MediaType(rawValue: action.title!) {
                           case .audio:
                               self.performSegue(withIdentifier: "addAudioSegue", sender: self)
                           case .image:
                               self.performSegue(withIdentifier: "AddImageSegue", sender: self)
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
    
    //MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let experience = experience {
            self.coordinate = experience.coordinate
            
        }
        updateViews()
    }
    
    func updateViews() {
         guard let experience = experience else { return }
         tableView.reloadData()
         titleTextField.text = experience.title
       //  descriptionTF.text = experience.subtitle
     }


    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return experience?.media.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MediaCell", for: indexPath)
        if let experience = experience {
                   cell.textLabel?.text = experience.media[indexPath.row].mediaType.rawValue
                   cell.detailTextLabel?.text = experience.media[indexPath.row].updatedDate?.formattedString() ?? experience.media[indexPath.row].createdDate.formattedString()
               }
               return cell
        }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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

 
   
    
    // MARK: - Navigation
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "AddImageSegue":
            let vc = segue.destination as! ImageViewController
       //     vc.delegate = self
        case "showImageSegue":
            let vc = segue.destination as! ImageViewController
       //     vc.delegate = self
       //     vc.media = selectedMedia
        case "addVideoSegue":
            let vc = segue.destination as! VideoViewController
            vc.delegate = self
        case "showVideoSegue":
            let vc = segue.destination as! VideoViewController
            vc.delegate = self
            vc.media = selectedMedia
        case "addAudioSegue":
            let vc = segue.destination as! AudioViewController
      //      vc.delegate = self
        case "showAudioSegue":
            let vc = segue.destination as! AudioViewController
        //    vc.delegate = self
       //     vc.media = selectedMedia
        default:
            break
        }
    }


}

extension ExperienceTableViewController: ExperienceTableViewControllerDelegate {
    func mediaAdded(media: Media) {
        if let experience = experience {
            experience.addMedia(media: media)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } else {
            let title = self.titleTextField.text ?? ""
          //  let subtitle = self.descriptionTF.text ?? ""
         //   let newExperience = Experience(title: title, subtitle: subtitle, coordinate: coordinate)
          //  experienceController?.add(newExperience: newExperience)
        //    experience = newExperience
         //   experience?.addMedia(media: media)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

