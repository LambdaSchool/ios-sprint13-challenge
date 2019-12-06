//
//  ExperienceViewController.swift
//  Experiences
//
//  Created by Isaac Lyons on 12/6/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import CoreLocation
import Photos

class ExperienceViewController: UIViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var recordAudioButton: UIButton!
    @IBOutlet weak var playAudioButton: UIButton!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    @IBOutlet weak var chooseImageButton: UIButton!
    
    //MARK: Properties
    
    var experienceController: ExperienceController?
    let locationController = LocationController()

    override func viewDidLoad() {
        super.viewDidLoad()

        titleTextField.delegate = self
        locationController.delegate = self
        
        updateViews()
    }
    
    //MARK: Private
    
    private func updateViews() {
        nextButton.isEnabled = !(titleTextField.text?.isEmpty ?? true)
        chooseImageButton.isHidden = imageView.image != nil
    }
    
    private func presentImagePickerController() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: Actions
    
    @IBAction func recordAudio(_ sender: UIButton) {
    }
    
    @IBAction func playAudio(_ sender: UIButton) {
    }
    
    @IBAction func nextTapped(_ sender: UIBarButtonItem) {
        locationController.requestLocation()
    }
    
    @IBAction func chooseImage(_ sender: UIButton) {
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch authorizationStatus {
        case .authorized:
            presentImagePickerController()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                if status == .authorized {
                    DispatchQueue.main.async {
                        self.presentImagePickerController()
                    }
                }
            }
        case .restricted:
            break
        case .denied:
            break
        @unknown default:
            break
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

extension ExperienceViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        updateViews()
        
        return true
    }
}

extension ExperienceViewController: LocationControllerDelegate {
    func update(locations: [CLLocation]) {
        guard let coordinate = locations.first?.coordinate,
            let title = titleTextField.text,
            !title.isEmpty else { return }
        
        experienceController?.createExperience(title: title, coordinate: coordinate, videoURL: nil, audioURL: nil)
        navigationController?.popViewController(animated: true)
    }
}

extension ExperienceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        imageView.image = image
        
        updateViews()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
