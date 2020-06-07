//
//  StoryExperienceViewController.swift
//  Experiences
//
//  Created by Kenny on 6/6/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit
import AVFoundation
import MapKit

class StoryExperienceViewController: UIViewController {
    var experience: Experience?

    private let experienceController = ExperienceController.shared


    var locationManager: CLLocationManager!
    var currentLocation: Location?

    var recordedURL: URL?
    lazy var audioRecorder = AudioRecorder(delegate: self)
    lazy var audioPlayer = AudioPlayer(delegate: self)

    let textViewPlaceholderText = "Tell your story here (optional)"

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var storyTextView: UITextView!
    @IBOutlet weak var timeElapsedLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }

    private func updateViews() {
        titleTextField.delegate = self
        storyTextView.delegate = self
        updateRecordingUI()
        updatePlayerUI()
        styleFields()
        getLocation()
        guard let experience = experience else { return }
        titleTextField.text = experience.subject
        recordedURL = experience.audioFile
        storyTextView.text = experience.body
    }

    private func getLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
    }

    private func styleFields() {
        storyTextView.layer.borderWidth = 1
        storyTextView.layer.borderColor = UIColor.black.cgColor
        titleTextField.layer.borderWidth = 1
        titleTextField.layer.borderColor = UIColor.black.cgColor
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        var fields: [String] = []
        if titleTextField.text?.isEmpty ?? true {
            fields.append("A title")
        }
        let message = fields.joined(separator: ",\n")
        if !fields.isEmpty {
            Alert.show(
                title: "Your experience is missing:",
                message: message,
                vc: self
            )
        }
        guard let title = titleTextField.text,
            !title.isEmpty,
            let location = currentLocation
        else { return }

        var text = storyTextView.text
        if text == textViewPlaceholderText {
            text = nil
        }
        if experience == nil {
            let experience = Experience(
                location: location,
                title: title,
                body: text,
                audioFile: recordedURL
            )

            experienceController.append(experience)
        } else {
            experience?.subject = title
            if text != textViewPlaceholderText && text != experience?.body {
                experience?.body = text
            }
            experience?.audioFile = recordedURL
        }
        navigationController?.popViewController(animated: true)
    }

    @IBAction func recordButtonTapped(_ sender: Any) {
        audioRecorder.toggleRecording()
    }

}

extension StoryExperienceViewController: AudioRecorderDelegate {
    func updateRecordingUI() {
        recordButton.isSelected = audioRecorder.isRecording
        displayElapsedTime()
    }

    private func displayElapsedTime() {
        let elapsedTime = audioRecorder.recorder?.currentTime ?? 0
        timeElapsedLabel.text = audioRecorder.timeIntervalFormatter.string(from: elapsedTime)
    }

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("finished")
        recordedURL = recorder.url
        audioPlayer.togglePlaying()
    }

}

extension StoryExperienceViewController: AudioPlayerUIDelegate {
    func updatePlayerUI() {

    }
}

extension StoryExperienceViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            self.currentLocation = Location(
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude
            )
        }
    }
}
