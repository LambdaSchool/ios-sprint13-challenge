//
//  NewExperienceViewController.swift
//  Experiences
//
//  Created by Michael on 3/13/20.
//  Copyright © 2020 Michael. All rights reserved.
//

import UIKit
import MapKit

class NewExperienceViewController: UIViewController {

    var coordinate: CLLocationCoordinate2D?
    
    var experience: Experience?
    
    var experienceController: ExperienceController?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var addVideoButton: UIButton!
    @IBOutlet weak var addVoiceRecordingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func addImageTapped(_ sender: Any) {
        guard let title = titleTextField.text, !title.isEmpty else {
            let alert = UIAlertController(title: "Wait!", message: "An experience needs a title, please add one!", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        guard let coordinate = coordinate else {
            print("No Coordinate")
            return
        }
        let newExperience = Experience(title: title, image: nil, video: nil, audio: nil, coordinate: coordinate)
        self.experience = newExperience
        self.performSegue(withIdentifier: "ImageSegue", sender: self)
    }
    
    @IBAction func addVideoTapped(_ sender: Any) {
        guard let title = titleTextField.text, !title.isEmpty else {
            let alert = UIAlertController(title: "Wait!", message: "An experience needs a title, please add one!", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        guard let coordinate = coordinate else {
            print("No Coordinate")
            return
        }
        let newExperience = Experience(title: title, image: nil, video: nil, audio: nil, coordinate: coordinate)
        self.experience = newExperience
        self.performSegue(withIdentifier: "VideoSegue", sender: self)
    }
    
    @IBAction func addVoiceRecordingTapped(_ sender: Any) {
        guard let title = titleTextField.text, !title.isEmpty else {
            let alert = UIAlertController(title: "Wait!", message: "An experience needs a title, please add one!", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        guard let coordinate = coordinate else {
            print("No Coordinate")
            return
        }
        let newExperience = Experience(title: title, image: nil, video: nil, audio: nil, coordinate: coordinate)
        self.experience = newExperience
        self.performSegue(withIdentifier: "AudioSegue", sender: self)
    }
    
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ImageSegue" {
            guard let imageVC = segue.destination as? ImageViewController else { return }
            imageVC.experience = experience
            imageVC.experienceController = experienceController
        } else if segue.identifier == "VideoSegue" {
            guard let videoVC = segue.destination as? VideoRecordingViewController else { return }
            videoVC.experience = experience
            videoVC.experienceController = experienceController
        } else if segue.identifier == "AudioSegue" {
            guard let audioVC = segue.destination as? VoiceRecordingViewController else { return }
            audioVC.experience = experience
            audioVC.experienceController = experienceController
        }
    }
}
