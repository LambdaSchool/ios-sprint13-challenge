//
//  NewExperienceViewController.swift
//  Experiences
//
//  Created by Shawn James on 6/5/20.
//  Copyright © 2020 Shawn James. All rights reserved.
//

import UIKit
import AVFoundation
import MapKit
import CoreLocation

protocol MapRefreshDelegate {
    func refreshMap()
}

class NewExperienceViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var addVideoButton: UIButton!
    @IBOutlet weak var addAudioButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    let experienceController = ExperienceController()
    let locationManager = CLLocationManager()
//    var newExperience: Experience?
    static var audio = URL(string: "https://www.google.com/")!
    var photo: UIImage? = nil
    var currentLocation: CLLocation?
    var mapRefreshDelegate: MapRefreshDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        disableButtonsUntilTitleEdit()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupLocationManager()
    }
    
    private func disableButtonsUntilTitleEdit() {
        addAudioButton.isEnabled = false
        addPhotoButton.isEnabled = false
        saveButton.isEnabled = false
    }
    
    private func setupLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        guard let title = titleTextField.text,
            !title.isEmpty,
        let location = currentLocation else { return }
        
        let newExperience = Experience(title: title, location: location, photo: self.photo, audio: NewExperienceViewController.audio)
        experienceController.saveExperience(newExperience) {
            dismiss(animated: true) {
                self.mapRefreshDelegate?.refreshMap()
            }
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func updateButtonIcons() {
        photo == nil ? addPhotoButton.setImage(UIImage(systemName: "camera"), for: .normal) : addPhotoButton.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        NewExperienceViewController.audio == nil ? addAudioButton.setImage(UIImage(systemName: "mic"), for: .normal) : addAudioButton.setImage(UIImage(systemName: "mic.fill"), for: .normal)
    }
    
    @IBAction func didBeginEditedTitle(_ sender: UITextField) {
        addAudioButton.isEnabled = true
        addPhotoButton.isEnabled = true
        saveButton.isEnabled = true
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToPhoto" {
            let photoViewController = segue.destination as! PhotoViewController
            photoViewController.photoSaveDelegate = self
        } else if segue.identifier == "GoToAudio" {
            let audioViewController = segue.destination as! AudioViewController
            guard let title = titleTextField.text, !title.isEmpty else {
                presentAlert()
                return
            }
            let fileName = title.trimmingCharacters(in: .whitespacesAndNewlines)
            audioViewController.fileName = fileName + ".m4a"
            audioViewController.audioSaveDelegate = self
        }
    }
    
    private func presentAlert() {
        let alert = UIAlertController(title: "Please enter a title first", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }

}

extension NewExperienceViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            locationManager.stopUpdatingLocation()
            self.currentLocation = location
        }
    }
}

extension NewExperienceViewController: AudioSaveDelegate, PhotoSaveDelegate {
    func returnAudioToSaveScreen(audio: URL) {
        NewExperienceViewController.audio = audio
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.updateButtonIcons()
        })
    }
    
    func returnPhotoToSaveScreen(photo: UIImage?) {
        self.photo = photo
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.updateButtonIcons()
        })
    }
    
}
