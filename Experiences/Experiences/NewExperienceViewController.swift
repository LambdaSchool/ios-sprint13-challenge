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

    var coordinate: CLLocationCoordinate2D? {
        didSet {
            
        }
    }
    
    var experiences: [Experience] = []
    
    var updatedExperience: Experience? {
        didSet {
            print(updatedExperience?.expTitle as Any)
        }
    }
    var expTitle = ""
    
    var experienceController: ExperienceController?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var addVideoButton: UIButton!
    @IBOutlet weak var addVoiceRecordingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(experiences.count)
        print(experiences.first?.expTitle)
    }
    
    @IBAction func saveTapped(_ sender: Any) {


        self.performSegue(withIdentifier: "MapViewSegue", sender: self)


    }
    
    @IBAction func addImageTapped(_ sender: Any) {
        guard let title = titleTextField.text, !title.isEmpty else {
            let alert = UIAlertController(title: "Wait!", message: "An experience needs a title, please add one!", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        expTitle = title
//        self.performSegue(withIdentifier: "ImageSegue", sender: self)
    }
    
    @IBAction func addVideoTapped(_ sender: Any) {
        guard let title = titleTextField.text, !title.isEmpty else {
            let alert = UIAlertController(title: "Wait!", message: "An experience needs a title, please add one!", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
//        let newExperience = Experience(title: title, image: nil, video: nil, audio: nil, coordinate: coordinate)
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
       
        self.performSegue(withIdentifier: "AudioSegue", sender: self)
    }
    
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ImageSegue" {
            guard let imageVC = segue.destination as? ImageViewController else { return }
                imageVC.title = expTitle
                imageVC.coordinate = coordinate 

            imageVC.experienceController = experienceController
        } else if segue.identifier == "VideoSegue" {
            guard let videoVC = segue.destination as? VideoRecordingViewController else { return }

            videoVC.experienceController = experienceController
        } else if segue.identifier == "AudioSegue" {
            guard let audioVC = segue.destination as? VoiceRecordingViewController else { return }
            audioVC.experienceController = experienceController
        } else if segue.identifier == "" {
            guard let mapViewVC = segue.destination as? MapKitViewController else { return }
            mapViewVC.experiences = experiences
            
        }
    }
}

extension NewExperienceViewController: ExperienceMediaDelegate {
    func experience(experience: Experience) {
        experiences.append(experience)
        print(experience.expTitle)
    }
    
    
}
