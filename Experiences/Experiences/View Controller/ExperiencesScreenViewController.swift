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
import CoreImage
import CoreImage.CIFilterBuiltins
import Photos
import CoreLocation


protocol NewExperienceDelegate {
    func didAddNewExperience(_ experience: Experience) -> Void
}

class ExperiencesScreenViewController: UIViewController {

    //MARK: - Properties
    var delegate: NewExperienceDelegate?
    let audioRecorderController = AudioRecorderController()
    var audioURL: URL?
    let context = CIContext(options: nil)
    var locationManager: CLLocationManager?
    
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
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("Error: The photo library is not available")
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        present(imagePicker, animated: true)
    }
    
    @IBAction func recordButtonPressed(_ sender: Any) {
        audioRecorderController.toggleRecording()
        audioRecorderController.audioRecorder?.delegate = self
        updateViews()
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
       locationPermission()
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
    
    func saveExperience() {
        locationPermission()
    }
    
    func locationPermission() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
    }
    
    func filterImage(image: UIImage) -> UIImage? {
        guard let cgImage = image.cgImage else { return nil }
        
        let ciImage = CIImage(cgImage: cgImage)
        
        let filter = CIFilter.colorControls()
        filter.inputImage = ciImage
        filter.brightness = 0.4
        
        guard let outputCIImage = filter.outputImage,
            let renderedCGImage = context.createCGImage(outputCIImage, from: CGRect(origin: .zero, size: image.size)) else { return nil }
        
        let outputUIImage = UIImage(cgImage: renderedCGImage)
        return outputUIImage.flattened
    }

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

extension ExperiencesScreenViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imageView.image = filterImage(image: image)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension ExperiencesScreenViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
         print("Error getting location: \(error)")
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager?.requestLocation()
        } else if status == .authorizedAlways {
            locationManager?.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        saveExperience()
    }
}
