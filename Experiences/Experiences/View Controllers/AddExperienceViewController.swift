//
//  AddExperienceViewController.swift
//  Experiences
//
//  Created by Christopher Devito on 5/8/20.
//  Copyright © 2020 Christopher Devito. All rights reserved.
//

import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins
import AVKit
import CoreLocation

class AddExperienceViewController: UIViewController {
    
    // MARK: - Properties
    var experienceController: ExperienceController?
    var image: UIImage?
    var audio: URL?
    let context = CIContext(options: nil)
    var audioRecorder: AVAudioRecorder?
    var isRecording: Bool {
        audioRecorder?.isRecording ?? false
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var recordAudioButton: UIButton!
    
    // MARK: - IBActions
    @IBAction func addImage(_ sender: Any) {
        presentImagePicker()
    }
    @IBAction func recordAudio(_ sender: Any) {
        if isRecording {
            stopRecording()
        } else {
            requestPermissionOrStartRecording()
        }
    }
    @IBAction func nextButtonTapped(_ sender: Any) {
    }
    @IBAction func saveWithoutVideo(_ sender: Any) {
        // Mandatory to create experience
        guard let title = titleTextField.text,
            !title.isEmpty else { return }
        experienceController?.createExperience(name: title)
        
        // Optional additions to experience
        if let image = image {
            experienceController?.addImageToExperience(name: title, image: image)
        }
        if let audio = audio {
            experienceController?.addAudioToExperience(name: title, audio: audio)
        }
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        try? prepareAudioSession()
    }
    
    func updateViews() {
        imageView.image = image
        recordAudioButton.isSelected = isRecording
    }
    
    // MARK: - Setup Methods
    func prepareAudioSession() throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.record)
        try session.setActive(true, options: [])
    }
    
    // MARK: - Action Methods
    func presentImagePicker() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func filterImage(originalImage: UIImage) {
        addImageButton.isHidden = true
        
        // Convert UIImage to CIImage
        guard let cgImage = originalImage.cgImage else { return }
        let ciImage = CIImage(cgImage: cgImage)
        
        // Create Filter
        let filter = CIFilter(name: "CIUnsharpMask")!
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        filter.setValue(2.5, forKey: kCIInputRadiusKey)
        filter.setValue(0.5, forKey: kCIInputIntensityKey)
        
        // Convert CIImage back to UIImage
        guard let outputCIImage = filter.outputImage,
            let outputCGImage = context.createCGImage(outputCIImage, from: CGRect(origin: .zero, size: originalImage.size))
            else { return }
        
        image = UIImage(cgImage: outputCGImage)
        updateViews()
    }
    
    func requestPermissionOrStartRecording() {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                guard granted == true else {
                    print("This app need microphone access")
                    return
                }
                
                print("Recording permission has been granted!")
                // NOTE: Invite the user to tap record again, since we just interrupted them, and they may not have been ready to record
            }
        case .denied:
            print("Microphone access has been blocked.")
            
            let alertController = UIAlertController(title: "Microphone Access Denied", message: "Please allow this app to access your Microphone.", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "Open Settings", style: .default) { (_) in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            })
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            
            present(alertController, animated: true, completion: nil)
        case .granted:
            startRecording()
        @unknown default:
            break
        }
    }
    
    func startRecording() {
        audio = experienceController?.createNewRecordingURL(name: titleTextField.text ?? "\(Date())")
        guard let recordingURL = audio else { return }
        
        let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1)!
        audioRecorder = try? AVAudioRecorder(url: recordingURL, format: format)
        audioRecorder?.delegate = self
        audioRecorder?.isMeteringEnabled = true
        audioRecorder?.record()
        updateViews()
        print("Starting to record")
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        updateViews()
        print("Stopping recording")
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

extension AddExperienceViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            filterImage(originalImage: image)
        }
        picker.dismiss(animated: true)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

extension AddExperienceViewController: UINavigationControllerDelegate {
}

extension AddExperienceViewController: AVAudioRecorderDelegate {
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let error = error {
            print("Audio record error: \(error)")
        }
        updateViews()
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
        }
        updateViews()
    }
}

extension AddExperienceViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("Found user's location: \(location)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location.")
    }
}
