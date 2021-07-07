//
//  EntryViewController.swift
//  Experiences
//
//  Created by Chris Gonzales on 4/10/20.
//  Copyright © 2020 Chris Gonzales. All rights reserved.
//

import UIKit

class EntryViewController: UIViewController {
    
    // MARK: - Properties
    
    let audioCommentController = AudioCommentController()
    
    var experienceController: ExperienceController?
    var geoTag: GeoTag?
    var descriptionText: String?
    var audioURL: URL?
    
    var isRecording: Bool {
           guard let audioRecorder = audioCommentController.audioRecorder else { return false}
        return audioRecorder.isRecording
    }

    // MARK: - Outlets
    
    @IBOutlet weak var DescriptionTextField: UITextField!
    @IBOutlet weak var recordAudioButton: UIButton!
    
    // MARK: - Actions
    
    @IBAction func recordAudioTapped(_ sender: UIButton) {
        guard let descriptionText = DescriptionTextField.text,
            !descriptionText.isEmpty else { return }
        if isRecording {
            audioCommentController.stopRecording()
            updateViews()
            dismiss(animated: true, completion: nil)
        } else {
            audioCommentController.requestPermissionOrStartRecording()
            audioURL = audioCommentController.createNewRecordingURL()
            updateViews()
        }
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        guard let descriptionText = DescriptionTextField.text,
        !descriptionText.isEmpty,
        let audioURL = audioURL,
        let geoTag = geoTag else { return }
        experienceController?.createExperience(geoTag: geoTag,
                                               description: descriptionText,
                                               audioComment: audioURL)
    }
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DescriptionTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    private func updateViews() {
        recordAudioButton.isSelected = isRecording
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ConstantValues.addPhotoSegue {
            guard let addPhotoVC = segue.destination as? PhotoViewController else { return }
            addPhotoVC.experienceController = experienceController
            addPhotoVC.geoTag = geoTag
            addPhotoVC.descriptionText = descriptionText
        }
        if segue.identifier == ConstantValues.addPhotoSegue {
            guard let addVideoVC = segue.destination as? VideoRecordingViewController else { return }
            addVideoVC.experienceController = experienceController
            addVideoVC.geoTag = geoTag
            addVideoVC.descriptionText = descriptionText
        }
    }
}

extension EntryViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
