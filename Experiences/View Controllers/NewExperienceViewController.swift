//
//  NewExperienceViewController.swift
//  Experiences
//
//  Created by Chad Parker on 7/17/20.
//  Copyright © 2020 Chad Parker. All rights reserved.
//

import UIKit
import MapKit

protocol NewExperienceDelegate {
    func newExperienceSaved(_ experience: Experience)
}

class NewExperienceViewController: UIViewController {

    // MARK: - Properties

    var delegate: NewExperienceDelegate!
    var currentLocation: CLLocationCoordinate2D!
    
    private let audioRecorder = AudioRecorder()
    private let audioPlayer = AudioPlayer()
    private var recordingURL: URL?

    @IBOutlet private var titleTextField: UITextField!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var recordingStartButton: UIButton!
    @IBOutlet private var recordingLabel: UILabel!
    @IBOutlet private var recordingStopButton: UIButton!
    @IBOutlet private var recordingPlayButton: UIButton!
    

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }


    // MARK: - Actions

    @IBAction func addPosterImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.modalPresentationStyle = .currentContext
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func startRecording(_ sender: UIButton) {
        recordingStartButton.isHidden = true
        recordingLabel.isHidden = false
        recordingStopButton.isHidden = false
        audioRecorder.startRecording()
    }
    
    @IBAction func stopRecording(_ sender: UIButton) {
        recordingStopButton.isHidden = true
        audioRecorder.stopRecording()

        recordingURL = audioRecorder.recordingURL
        guard let audioURL = recordingURL else {
            recordingLabel.text = "Recording error."
            return
        }
        recordingLabel.text = "Recording Saved."
        audioPlayer.loadAudio(url: audioURL)
        recordingPlayButton.isHidden = false
    }
    
    @IBAction func playRecording(_ sender: Any) {
        audioPlayer.togglePlayback()
        if audioPlayer.isPlaying {
            recordingPlayButton.setTitle("Pause", for: .normal)
        } else {
            recordingPlayButton.setTitle("Play", for: .normal)
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func doneButtonPressed(_ sender: Any) {
        guard let title = titleTextField.text, !title.isEmpty else { return }

        let newExperience = Experience(title: title, image: imageView.image, audioURL: recordingURL, location: currentLocation)
        delegate.newExperienceSaved(newExperience)

        dismiss(animated: true, completion: nil)
    }
}


// MARK: - ImagePicker Delegate

extension NewExperienceViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { fatalError("No image from picker") }
        
        imageView.image = ImageProcessor.desaturate(image)
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
