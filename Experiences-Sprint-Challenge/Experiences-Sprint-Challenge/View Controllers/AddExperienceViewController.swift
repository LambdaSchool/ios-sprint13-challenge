//
//  AddExperienceViewController.swift
//  Experiences-Sprint-Challenge
//
//  Created by Matthew Martindale on 7/19/20.
//  Copyright © 2020 Matthew Martindale. All rights reserved.
//

import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins
import AVFoundation
import MapKit

class AddExperienceViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var micButton: UIButton!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var recordingSuccessful: UIImageView!
    
    // MARK: - Properties
    var mapView: MKMapView?
    var latitude: Double?
    var longitude: Double?
    private let context = CIContext()
    private let colorControlFilter = CIFilter.colorControls()
    private var audioRecorder: AVAudioRecorder?
    private var recordingURL: URL?
    var isRecording: Bool {
        audioRecorder?.isRecording ?? false
    }
    // MARK: - View Controller Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    private func setupViews() {
        let configuration = UIImage.SymbolConfiguration(pointSize: 40)
        
        // setup photoImage
        let photoImage = UIImage(systemName: "photo", withConfiguration: configuration)
        photoButton.setImage(photoImage, for: .normal)
        photoButton.layer.cornerRadius = 12
        
        // setup micImage
        let micImage = UIImage(systemName: "mic.fill", withConfiguration: configuration)
        micButton.setImage(micImage, for: .normal)
        micButton.layer.cornerRadius = 12
    }

    // MARK: - Methods
    func updateViews() {
        photoButton.isEnabled = !isRecording
        saveButton.isEnabled = !isRecording
        
        if isRecording {
            micButton.isSelected = true
            let configuration = UIImage.SymbolConfiguration(pointSize: 40)
            let stopRecordingImage = UIImage(systemName: "stop.circle", withConfiguration: configuration)
            let redStopRecording = stopRecordingImage?.withTintColor(.systemRed)
            micButton.setImage(redStopRecording, for: .selected)
        } else if !isRecording {
            micButton.isSelected = false
        }
    }
    
    private func presentImagePickerController() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("The photo library is not available")
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func saturateImage(_ inputImage: CIImage) -> UIImage? {
        colorControlFilter.inputImage = inputImage
        colorControlFilter.saturation = 2.0
        
        guard let outputImage = colorControlFilter.outputImage else { return nil}
        
        return UIImage(ciImage: outputImage)
    }
    
    func prepareAudioSession() throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playAndRecord, options: [.defaultToSpeaker])
        try session.setActive(true, options: []) // can fail if on a phone call, for instance
    }
    
    func requestPermissionOrStartRecording() {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                guard granted == true else {
                    print("We need microphone access")
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
    
    func createNewRecordingURL() -> URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let name = ISO8601DateFormatter.string(from: Date(), timeZone: .current, formatOptions: .withInternetDateTime)
        let file = documents.appendingPathComponent(name, isDirectory: false).appendingPathExtension("caf")
        
        return file
    }
    
    func startRecording() {
        do {
            try prepareAudioSession()
        } catch {
            print("Cannot record audio: \(error)")
            return
        }
        
        recordingURL = createNewRecordingURL()
        
        let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1)!
        
        do {
            audioRecorder = try AVAudioRecorder(url: recordingURL!, format: format)
            audioRecorder?.delegate = self
            audioRecorder?.record()
            updateViews()
        } catch {
            preconditionFailure("The audio recorder could not be created with \(recordingURL!) and \(format): \(error)")
        }
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        updateViews()
    }
    
    // MARK: - IBActions
    @IBAction func imageButtonTapped(_ sender: UIButton) {
        presentImagePickerController()
    }
    
    @IBAction func recordButtonTapped(_ sender: UIButton) {
        if isRecording {
            stopRecording()
        } else {
            requestPermissionOrStartRecording()
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let latitude = latitude,
            let longitude = longitude else { return }
        let newExperience = Experience(title: titleTextField.text, image: imageView.image, audioURL: recordingURL, latitude: latitude, longitude: longitude)
        mapView?.addAnnotation(newExperience)
        
        navigationController?.popToRootViewController(animated: true)
    }
    
}

extension AddExperienceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let uiImage = info[.originalImage] as? UIImage else { return }
        guard let coreImage = CIImage(image: uiImage) else { return }
        guard let image = saturateImage(coreImage) else { return }
        imageView.image = image
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension AddExperienceViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if recordingURL != nil {
            recordingSuccessful.isHidden = false
        }
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let error = error {
            print("Error Audio Recording: \(error)")
        }
    }
}
