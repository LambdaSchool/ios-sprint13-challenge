//
//  NewExperienceViewController.swift
//  Experiences
//
//  Created by Michael on 3/13/20.
//  Copyright © 2020 Michael. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class NewExperienceViewController: UIViewController {

    var coordinate: CLLocationCoordinate2D? {
        didSet {
            print(coordinate as Any)
        }
    }
    
    var experience: Experience!
    
    var expWithMedia: Experience!
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var addVideoButton: UIButton!
    @IBOutlet weak var addVoiceRecordingButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(forName: .saveTapped, object: nil, queue: nil) { (catchNotification) in
            guard let addMediaExp = catchNotification.userInfo?[mediaAdded] else { return }
            self.experience = addMediaExp as? Experience
        }
        updateViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        let experienceDictionary = [experienceSaved: experience] as! [String : Experience]
        NotificationCenter.default.post(name: .saveTapped, object: nil, userInfo: experienceDictionary)
        navigationController?.popToRootViewController(animated: true)
    }
    
    func updateViews() {
        titleTextField.layer.borderWidth = 2.0
        titleTextField.layer.cornerRadius = 8
        titleTextField.layer.borderColor = #colorLiteral(red: 0.1850692332, green: 0.1410367489, blue: 0.7820795178, alpha: 1)
        addImageButton.layer.cornerRadius = 8
        addVideoButton.layer.cornerRadius = 8
        addVoiceRecordingButton.layer.cornerRadius = 8
    }
    
    @IBAction func addImageTapped(_ sender: Any) {
        guard
            let title = titleTextField.text,
            let coordinate = coordinate,
            !title.isEmpty else {
            let alert = UIAlertController(title: "Wait!", message: "An experience needs a title, please add one!", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        let newExperience = Experience(title: title, image: nil, video: nil, audio: nil, coordinate: coordinate)
        self.experience = newExperience
    }
    
    @IBAction func addVideoTapped(_ sender: Any) {
        guard
            let title = titleTextField.text,
            let coordinate = coordinate,
            !title.isEmpty else {
            let alert = UIAlertController(title: "Wait!", message: "An experience needs a title, please add one!", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        let newExperience = Experience(title: title, image: nil, video: nil, audio: nil, coordinate: coordinate)
        self.experience = newExperience
    }
    
    @IBAction func addVoiceRecordingTapped(_ sender: Any) {
        guard
            let title = titleTextField.text,
            let coordinate = coordinate,
            !title.isEmpty else {
            let alert = UIAlertController(title: "Wait!", message: "An experience needs a title, please add one!", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        let newExperience = Experience(title: title, image: nil, video: nil, audio: nil, coordinate: coordinate)
        self.experience = newExperience
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ImageSegue" {
            guard let imageVC = segue.destination as? ImageViewController else { return }
                imageVC.experience = experience
        } else if segue.identifier == "VideoSegue" {
            guard let videoVC = segue.destination as? VideoRecordingViewController else { return }
                videoVC.experience = experience
        } else if segue.identifier == "AudioSegue" {
            guard let audioVC = segue.destination as? VoiceRecordingViewController else { return }
                audioVC.experience = experience
        }
    }
}


