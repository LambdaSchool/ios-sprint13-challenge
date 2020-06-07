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
    // MARK: - Properties -
    var experience: Experience?

    private let experienceController = ExperienceController.shared
    //Location
    var locationManager: CLLocationManager!
    var currentLocation: Location?
    //Text
    let textViewPlaceholderText = "Tell your story here (optional)"
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var storyTextView: UITextView!
    //Audio
    var recordedURL: URL?
    lazy var recordingController = AudioRecorder(delegate: self)
    lazy var audioController = AudioPlayer(delegate: self)
    @IBOutlet weak var timeElapsedLabel: UILabel!
    //Recording
    @IBOutlet weak var recordButton: UIButton!

    @IBAction func recordButtonTapped(_ sender: Any) {
        if !playButton.isSelected {
            recordingController.toggleRecording()
            if recordingController.isRecording {
                playButton.isUserInteractionEnabled = false
            }
        }
    }
    //Playback
    @IBOutlet weak var playButton: UIButton!

    @IBAction func togglePlayback(_ sender: UIButton) {
        if !recordButton.isSelected {
            audioController.togglePlaying()
            if audioController.isPlaying {
                recordButton.isUserInteractionEnabled = false
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if recordedURL != nil {
            audioController.togglePlaying()
        }
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
                subject: title,
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



}

extension StoryExperienceViewController: AudioPlayerUIDelegate {
    func updatePlayerUI() {
        playButton.isSelected = audioController.isPlaying
        displayElapsedTime()
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        displayElapsedTime()
        recordButton.isUserInteractionEnabled = true
    }
}

extension StoryExperienceViewController: AudioRecorderDelegate {
    func updateRecordingUI() {
        recordButton.isSelected = recordingController.isRecording
        displayElapsedTime()
    }

    private func displayElapsedTime() {
        if recordButton.isSelected {
            let elapsedTime = recordingController.recorder?.currentTime ?? 0
            timeElapsedLabel.text = recordingController.timeIntervalFormatter.string(from: elapsedTime)
        } else if playButton.isSelected {
            let elapsedTime = audioController.player?.currentTime ?? 0
            timeElapsedLabel.text = recordingController.timeIntervalFormatter.string(from: elapsedTime)
        }
    }

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        recordedURL = recorder.url
        print("Recorded to: \(recorder.url)")
        playButton.isUserInteractionEnabled = true
        audioController.togglePlaying()
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
