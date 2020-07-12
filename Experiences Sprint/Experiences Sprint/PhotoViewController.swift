//
//  PhotoViewController.swift
//  Experiences Sprint
//
//  Created by Stephanie Ballard on 7/10/20.
//  Copyright © 2020 Stephanie Ballard. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class PhotoViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var recordButton: UIButton!
    
    // MARK: - Properties -
    
    var experience: Experience?
    var recordingURL: URL?
    var audioRecorder: AVAudioRecorder?
    
    var audioPlayer: AVAudioPlayer? {
        didSet {
            guard let audioPlayer = audioPlayer else { return }
            audioPlayer.delegate = self
            audioPlayer.isMeteringEnabled = true
        }
    }
    
    var isPlaying: Bool {
        return audioPlayer?.isPlaying ?? false
    }
    
    var isRecording: Bool {
        audioRecorder?.isRecording ?? false
    }
    
    // MARK: - Lifecycle Methods -
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Actions -
    
    @IBAction func recordButtonTapped(_ sender: UIButton) {
        if isRecording {
            stopRecording()
        } else {
            startRecording()
        }
    }
    
    @IBAction func photosButtonTapped(_ sender: UIButton) {
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
            
        @unknown default:
            print("FatalError")
        }
        presentImagePickerController()
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Helper Methods -
    
    func updateViews() {
        
    }
    
    // MARK: - Audio Recording Methods -
    func createNewRecordingURL() -> URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let name = ISO8601DateFormatter.string(from: Date(), timeZone: .current, formatOptions: .withInternetDateTime)
        let file = documents.appendingPathComponent(name, isDirectory: false).appendingPathExtension("caf")
        
        print("recording URL: \(file)")
        
        return file
    }
    
    func startRecording() {
        // Grab the recording URL
        recordingURL = createNewRecordingURL()
        
        // Check for permission
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            guard granted else {
                NSLog("We need microphone access")
                return
            }
            
            // Set up the recorder (give it the settings we want, etc.)
            guard let recordingURL = self.recordingURL else {
                NSLog("No recording URL available")
                return
                
            }
            let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1)!
            do {
                self.audioRecorder = try AVAudioRecorder(url: recordingURL, format: format)
                self.audioRecorder?.delegate = self
                self.audioRecorder?.isMeteringEnabled = true
                // Start recording
                self.audioRecorder?.record()
            } catch {
                NSLog("Error setting up audio recorder: \(error)")
            }
        }
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        audioRecorder = nil
    }
    
    // MARK: - Photo Picker Methods -
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
}

// MARK: - Extensions -
extension PhotoViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        DispatchQueue.main.async {
            self.updateViews()
        }
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let error = error {
            NSLog("Error playing audio: \(error)")
        }
    }
}

extension PhotoViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if let recordingURL = recordingURL {
            audioPlayer = try? AVAudioPlayer(contentsOf: recordingURL)
            self.recordingURL = nil
            
            DispatchQueue.main.async {
                self.updateViews()
            }
        }
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let error = error {
            NSLog("Error recording audio: \(error)")
        }
    }
}
