//
//  ExperienceViewController.swift
//  Experiences
//
//  Created by Lambda_School_Loaner_214 on 11/2/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import CoreLocation

protocol ExperienceViewControllerDelegate {
    func mediaAdded(media: Media)
}

class ExperienceViewController: UIViewController {
    
    var experienceController: ExperienceController?
    var experience: Experience?
    var coordinate: CLLocationCoordinate2D!
    var selectedMedia: Media?

    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var descriptionTF: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var uiView: ContainerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        updateViews()
    }
    
    func updateViews() {
        guard let experience = experience else { return }
        tableView.reloadData()
        titleTF.text = experience.title
        descriptionTF.text = experience.subtitle
    }
    
    @IBAction func addTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Add Media", message: "Which type?", preferredStyle: .actionSheet)
        for type in MediaType.allCases {
            alert.addAction(UIAlertAction(title: type.rawValue, style: .default, handler: { (action) in
                DispatchQueue.main.async {
                    switch MediaType(rawValue: action.title!) {
                    case .audio:
                        self.performSegue(withIdentifier: "AudioSegue", sender: self)
                    case .image:
                        self.performSegue(withIdentifier: "ImageSegue", sender: self)
                    case .video:
                        self.performSegue(withIdentifier: "VideoSegue", sender: self)
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
            controller.add(newExperience: experience)
        } else {
            controller.add(newExperience: Experience(title: title, subtitle: description, coordinate: coordinate))
        }
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "ImageSegue":
            let vc = segue.destination as! ImageViewController
            vc.delegate = self
            vc.media = selectedMedia
        case "VideoSegue":
            let vc = segue.destination as! VideoViewController
            vc.delegate = self
            vc.media = selectedMedia
        case "AudioSegue":
            let vc = segue.destination as! AudioViewController
            vc.delegate = self
            vc.media = selectedMedia
        default:
            break
        }
    }
}

extension ExperienceViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return experience?.media.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MediaCell", for: indexPath)
        if let experience = experience {
            cell.textLabel?.text = experience.media[indexPath.row].mediaType.rawValue
            cell.detailTextLabel?.text = experience.media[indexPath.row].date.formattedString()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMedia = experience?.media[indexPath.row]
        switch selectedMedia?.mediaType {
        case .audio:
            self.performSegue(withIdentifier: "AudioSegue", sender: self)
        case .image:
            self.performSegue(withIdentifier: "ImageSegue", sender: self)
        case .video:
            self.performSegue(withIdentifier: "VideoSegue", sender: self)
        default:
            break
        }
    }
}

extension ExperienceViewController: ExperienceViewControllerDelegate {
    func mediaAdded(media: Media) {
        let title = self.titleTF.text ?? ""
        let subtitle = self.descriptionTF.text ?? ""
        experience = Experience(title: title, subtitle: subtitle, coordinate: coordinate)
        //experienceController?.add(newExperience: newExperience)
        experience?.addMedia(mediaType: media.mediaType, url: media.mediaURL, data: media.mediaData)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
