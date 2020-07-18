//
//  ExperiencesScreenViewController.swift
//  Experiences
//
//  Created by Claudia Maciel on 7/17/20.
//  Copyright © 2020 thecoderpilot. All rights reserved.
//

import UIKit
import MapKit
import AVFoundation

protocol NewExperienceDelegate {
    func didAddNewExperience(_ experience: Experience) -> Void
}

class ExperiencesScreenViewController: UIViewController {

    //MARK: - Properties
    var delegate: NewExperienceDelegate?
    let audioRecorderController = AudioRecorderController()
    var audioURL: URL?
    
    //MARK: - IBOutlet
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var recordButton: UIButton!
    @IBOutlet var addPosterImageButton: UIButton!
    @IBOutlet var saveButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: - IBAction
    @IBAction func addImageButtonPressed(_ sender: Any) {
    }
    
    @IBAction func recordButtonPressed(_ sender: Any) {
        audioRecorderController.toggleRecording()
        audioRecorderController.audioRecorder?.delegate = self
        updateViews()
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        guard let title = titleTextField.text, !title.isEmpty else { return }
        
        let location = CLLocation()
        let longitude = location.coordinate.longitude
        let latitude = location.coordinate.latitude
        
        let experience = Experience(title: title, audioURL: audioURL, image: imageView.image?.pngData(), longitude: longitude, latitude: latitude)
        
        delegate?.didAddNewExperience(experience)
        
        dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Functions
    func updateViews() {
        let audioRecorder = audioRecorderController.audioRecorder
        recordButton.isSelected = audioRecorder?.isRecording ?? false
        
        switch recordButton.isSelected {
        case true:
            saveButton.isEnabled = false
        case false:
            saveButton.isEnabled = true
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - Extensions
extension ExperiencesScreenViewController: AVAudioRecorderDelegate {
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

extension ExperiencesScreenViewController: AudioRecorderControllerDelegate {
    func didNotReceivePermission() {
        print("Microphone access has been blocked.")

        let alertController = UIAlertController(title: "Microphone Access Denied", message: "Please allow this app to access your Microphone.", preferredStyle: .alert)

        alertController.addAction(UIAlertAction(title: "Open Settings", style: .default) { (_) in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        })

        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))

        present(alertController, animated: true)
    }
}
