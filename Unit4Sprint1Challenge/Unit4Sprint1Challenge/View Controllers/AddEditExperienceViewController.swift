//
//  NewPostViewController.swift
//  Unit4Sprint1Challenge
//
//  Created by Jon Bash on 2020-01-17.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import UIKit

class AddEditExperienceViewController: ShiftableViewController {

    var experienceController: ExperienceController!

    var experience: Experience?

    var imageData: Data?
    var videoData: Data?
    var audioData: Data?

    var locationHelper = LocationHelper()

    var hasExperienceData: Bool {
        (descriptionTextView.text != nil && !descriptionTextView.text.isEmpty) ||
            imageData != nil ||
            videoData != nil ||
            audioData != nil
    }
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!

    @IBAction func saveButtonTapped(_ sender: Any) {
        saveExperience()
    }

    func saveExperience() {
        guard
            let title = titleTextField.text, !title.isEmpty,
            hasExperienceData
            else { return }
        let experience = Experience(title: title)
        experience.imageData = imageData
        experience.videoData = videoData
        experience.audioData = audioData
        experience.geotag = locationHelper.currentLocation

        experienceController.makeModel(experience)
        navigationController?.popToRootViewController(animated: true)
    }
}

// MARK: - Delegates

extension AddEditExperienceViewController: ImageVCDelegate {
    func imageVCDidPickImage(withData data: Data?) {
        self.imageData = data
    }
}

extension AddEditExperienceViewController: VideoRecorderDelegate {
    func videoRecorderDidFinishRecording(withData videoData: Data?) {
        self.videoData = videoData
    }

    func videoRecorderDidDeleteRecording() {
        self.videoData = nil
    }
}

extension AddEditExperienceViewController: AudioVCDelegate {
    func audioVCDidFinishRecording(with data: Data?) {
        self.audioData = data
    }
}
