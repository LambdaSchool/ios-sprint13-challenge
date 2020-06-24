//
//  ExperienceViewController.swift
//  Experiences
//
//  Created by Ryan Murphy on 7/12/19.
//  Copyright © 2019 Ryan Murphy. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class ExperienceViewController: UIViewController, AVAudioRecorderDelegate, UITextFieldDelegate {
    
    var imageData: Data?
    var audioURL: URL?
    private var recorder: AVAudioRecorder?
    private var isRecording: Bool {
        return recorder?.isRecording ?? false
    }
    
    var experienceController: ExperienceController?
    var originalImage: UIImage? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var captionTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        captionTextField.delegate = self
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
        filter.setValue(0.9, forKey: kCIInputIntensityKey)
        
        guard let outputCIImage = filter.outputImage else { return image }
        
        guard let outputCGImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) else { return image }
        
        let filteredImage = UIImage(cgImage: outputCGImage)
        
        imageData = filteredImage.jpegData(compressionQuality: 1)
        
        return filteredImage
        
    }
    
    private  let filter = CIFilter(name:"CISepiaTone")!
    private let context = CIContext(options: nil)
    
    
    func requestMicrophonePermission() {
        let session = AVAudioSession.sharedInstance()
        
        session.requestRecordPermission { (granted) in
            guard granted else {
                NSLog("Application needs permission to record.")
                return
            }
            
            do {
                try session.setCategory(.playAndRecord, mode: .default, options: [])
                try session.setActive(true, options: [])
            } catch {
                NSLog("Error: \(error)")
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
    
    
    private func presentImagePickerController() {
        
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            presentInformationalAlertController(title: "Error", message: "Photo library unavailable")
            return
        }
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddVideoRecording" {
            guard let destinationViewController = segue.destination as? CameraViewController else { return }
            
            destinationViewController.experienceController = experienceController
            destinationViewController.imageTitle = captionTextField.text
            destinationViewController.audioURL = audioURL
            destinationViewController.imageData = imageData
        }
    }
    
    @IBAction func addImageButtonPressed(_ sender: Any) {
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch authorizationStatus {
        case .authorized:
            presentImagePickerController()
        case .notDetermined:
            
            PHPhotoLibrary.requestAuthorization { (status) in
                
                guard status == .authorized else {
                    NSLog("No access to Photo Library")
                    self.presentInformationalAlertController(title: "Error", message: "Allow app to access Photo Library")
                    return
                }
                
                self.presentImagePickerController()
            }
            
        case .denied:
            self.presentInformationalAlertController(title: "Error", message: "Allow permissions to access library.")
        case .restricted:
            self.presentInformationalAlertController(title: "Error", message: "Unable to access the photo library.")
            
        @unknown default:
            fatalError()
        }
        presentImagePickerController()
    }
    @IBAction func recordAudioButtonPressed(_ sender: Any) {
        defer { updateButtons() }
        guard !isRecording else {
            recorder?.stop()
            return
        }
        
        do {
            let format = AVAudioFormat(standardFormatWithSampleRate: 44_100.0, channels: 2)!
            recorder = try AVAudioRecorder(url: newRecordingURL(), format: format)
            recorder?.delegate = self
            recorder?.record()
        } catch {
            NSLog("Unable to record: \(error)")
        }
    }
    

    
}

extension ExperienceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        addImageButton.setTitle("", for: [])
        
        
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



