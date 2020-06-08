//
//  NewExperienceViewController.swift
//  Experiences
//
//  Created by Hunter Oppel on 6/8/20.
//  Copyright © 2020 LambdaSchool. All rights reserved.
//

import UIKit

import MapKit
import AVFoundation

import CoreImage
import CoreImage.CIFilterBuiltins
import Photos

protocol NewExperienceDelegate {
    func didAddNewExperience(_ experience: Experience) -> Void
}

class NewExperienceViewController: UIViewController {
    
    let audioRecorderController = AudioRecorderController()
    
    var delegate: NewExperienceDelegate?
    var audioURL: URL?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var detailsTextView: UITextView!
    @IBOutlet weak var recordAudioButton: UIButton!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBAction func toggleRecording(_ sender: Any) {
        toggleRecording()
    }
    
    @IBAction func saveExperience(_ sender: Any) {
        saveExperience()
    }
    
    @IBAction func addPhoto(_ sender: Any) {
        addPhoto()
    }
    
    private func toggleRecording() {
        audioRecorderController.toggleRecording()
        audioRecorderController.audioRecorder?.delegate = self
        updateViews()
    }
    
    private func saveExperience() {
        guard let title = titleTextField.text,
            !title.isEmpty else {
                
                return
        }
        
        let location = CLLocation()
        let longitude = location.coordinate.longitude
        let latitude = location.coordinate.latitude
        
        let experience = Experience(title: title,
                                    details: detailsTextView.text,
                                    audioURL: audioURL,
                                    image: imageView.image?.pngData(),
                                    longitude: longitude,
                                    latitude: latitude)
        
        delegate?.didAddNewExperience(experience)
        
        navigationController?.popViewController(animated: true)
    }
    
    private func addPhoto() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("Error: The photo library is not available")
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        present(imagePicker, animated: true)
    }
    
    private func updateViews() {
        let audioRecorder = audioRecorderController.audioRecorder
        
        recordAudioButton.isSelected = audioRecorder?.isRecording ?? false
        
        switch recordAudioButton.isSelected {
        case true:
            saveButton.isEnabled = false
        case false:
            saveButton.isEnabled = true
        }
    }
}

extension NewExperienceViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if let recordingURL = audioRecorderController.recordingURL {
            print("Finished recording: \(recordingURL.path)")
            
            audioURL = recordingURL
        } else {
            print("Did not successfully finish recording")
        }
        
        DispatchQueue.main.async {
            self.updateViews()
        }
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let error = error {
            NSLog("Error occured during recording: \(error)")
        }
        
        DispatchQueue.main.async {
            self.updateViews()
        }
    }
}

extension NewExperienceViewController: AudioRecorderControllerDelegate {
    func didNotRecievePermission() {
        print("Microphone access has been blocked.")
        
        let alertController = UIAlertController(title: "Microphone Access Denied", message: "Please allow this app to access your Microphone.", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Open Settings", style: .default) { (_) in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        })
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        present(alertController, animated: true)
    }
}

extension NewExperienceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            
            imageView.image = image
        }
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}
