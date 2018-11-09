//
//  ExperiencesHomeViewController.swift
//  Experiences
//
//  Created by Moin Uddin on 11/9/18.
//  Copyright © 2018 Moin Uddin. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
class ExperiencesHomeViewController: UIViewController, AVAudioRecorderDelegate, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.delegate = self
        requestMicrophonePermission()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func updateViews() {
        guard let originalImage = originalImage else { return }
        
        imageView.image = image(byFiltering: originalImage)
    }
    private func image(byFiltering image: UIImage) -> UIImage {
        guard let cgImage = image.cgImage else { return image }
        let ciImage = CIImage(cgImage: cgImage)
        
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        filter.setValue(3, forKey: kCIInputSaturationKey)
        guard let outputCIImage = filter.outputImage else { return image }
        
        guard let outputCGImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) else { return image }
        
        let filteredImage = UIImage(cgImage: outputCGImage)
        
        imageData = filteredImage.jpegData(compressionQuality: 1)
        
        return filteredImage
        
    }
    
    private let filter = CIFilter(name: "CIColorControls")!
    private let context = CIContext(options: nil)
    
    
    func requestMicrophonePermission() {
        let session = AVAudioSession.sharedInstance()
        
        session.requestRecordPermission { (granted) in
            guard granted else {
                NSLog("Please give the application permission to record in Settings.")
                return
            }
            
            do {
                try session.setCategory(.playAndRecord, mode: .default, options: [])
                try session.setActive(true, options: [])
            } catch {
                NSLog("Error setting up AVAudiosSession: \(error)")
            }
        }
    }
    
    private func updateButtons() {
        isRecording ? recordButton.setTitle("Stop", for: .normal) : recordButton.setTitle("Record", for: .normal)
    }
    
    
    private func newRecordingURL() -> URL {
        let documentsDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        return documentsDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("caf")
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        audioURL = recorder.url
        self.recorder = nil
        updateButtons()
    }
    
    var imageData: Data?
    var audioURL: URL?
    private var recorder: AVAudioRecorder?
    private var isRecording: Bool {
        return recorder?.isRecording ?? false
    }
    
    private func presentImagePickerController() {
        
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            presentInformationalAlertController(title: "Error", message: "The photo library is unavailable")
            return
        }
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func addPoster(_ sender: Any) {
        
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch authorizationStatus {
        case .authorized:
            presentImagePickerController()
        case .notDetermined:
            
            PHPhotoLibrary.requestAuthorization { (status) in
                
                guard status == .authorized else {
                    NSLog("User did not authorize access to the photo library")
                    self.presentInformationalAlertController(title: "Error", message: "In order to access the photo library, you must allow this application access to it.")
                    return
                }
                
                self.presentImagePickerController()
            }
            
        case .denied:
            self.presentInformationalAlertController(title: "Error", message: "In order to access the photo library, you must allow this application access to it.")
        case .restricted:
            self.presentInformationalAlertController(title: "Error", message: "Unable to access the photo library. Your device's restrictions do not allow access.")
            
        }
        presentImagePickerController()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewVideoRecording" {
            guard let destinationVC = segue.destination as? CameraViewController else { return }
            
            destinationVC.experienceController = experienceController
            destinationVC.imageTitle = titleTextField.text
            destinationVC.audioURL = audioURL
            destinationVC.imageData = imageData
        }
    }
    
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var addPosterButton: UIButton!
    
    
    @IBAction func record(_ sender: Any) {
        defer { updateButtons() }
        guard !isRecording else {
            recorder?.stop()
            return
        }
        
        do {
            let format = AVAudioFormat(standardFormatWithSampleRate: 44100.0, channels: 2)!
            recorder = try AVAudioRecorder(url: newRecordingURL(), format: format)
            recorder?.delegate = self
            recorder?.record()
        } catch {
            NSLog("Unable to start recording: \(error)")
        }
    }
    
    var experienceController: ExperienceController?
    
    
    var originalImage: UIImage? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var recordButton: UIButton!
    
}

extension ExperiencesHomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        addPosterButton.setTitle("", for: [])
        
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        originalImage = image
        
    }
    private func presentInformationalAlertController(title: String?, message: String?, dismissActionCompletion: ((UIAlertAction) -> Void)? = nil, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: dismissActionCompletion)
        alertController.addAction(dismissAction)
        present(alertController, animated: true, completion: completion)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
