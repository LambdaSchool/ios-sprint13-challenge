//
//  AddNewExperienceViewController.swift
//  Experiences
//
//  Created by Chris Dobek on 6/7/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import UIKit
import AVFoundation
import MapKit
import CoreLocation

protocol MapRefreshDelegate {
    func refreshMap()
}

class AddNewExperienceViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var addAudioButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    
    let experienceController = ExperienceController()
    let locationManager = CLLocationManager()
    static var audio = URL(string: "https://www.google.com/")!
    var audioWasSaved = false
    var image: UIImage? = nil
    var currentLocation: CLLocation?
    var mapRefreshDelegate: MapRefreshDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        disableButtonsUntilTitleEdit()
    }
    private func disableButtonsUntilTitleEdit() {
        addAudioButton.isEnabled = false
        addImageButton.isEnabled = false
        saveButton.isEnabled = false
    }
    override func viewDidAppear(_ animated: Bool) {
        setupLocationManager()
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
        
        let newExperience = Experience(title: title, location: location, image: self.image, audio: AddNewExperienceViewController.audio)
        experienceController.savedExperience(newExperience) {
            dismiss(animated: true) {
                self.mapRefreshDelegate?.refreshMap()
            }
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func updateButtonIcons() {
        image == nil ? addImageButton.setImage(UIImage(systemName: "camera"), for: .normal) : addImageButton.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        audioWasSaved == false ? addAudioButton.setImage(UIImage(systemName: "mic"), for: .normal) : addAudioButton.setImage(UIImage(systemName: "mic.fill"), for: .normal)
    }
    
    @IBAction func didBeginEditedTitle(_ sender: UITextField) {
        addAudioButton.isEnabled = true
        addImageButton.isEnabled = true
        saveButton.isEnabled = true
    }
        
        // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowAddImage" {
            let imageViewController = segue.destination as! ImageViewController
            imageViewController.imageSaveDelegate = self
        } else if segue.identifier == "ShowAddRecording" {
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

extension AddNewExperienceViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            locationManager.stopUpdatingLocation()
            self.currentLocation = location
        }
    }
}

extension AddNewExperienceViewController: AudioSaveDelegate, ImageSaveDelegate {
    
    func returnAudioToSaveScreen(audio: URL) {
        AddNewExperienceViewController.audio = audio
        audioWasSaved = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.updateButtonIcons()
        })
    }
    
    func returnImageToSaveScreen(image: UIImage?) {
        self.image = image
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.updateButtonIcons()
        })
    }
    
}

