//
//  ExperienceViewController.swift
//  Experiences
//
//  Created by Rick Wolter on 2/14/20.
//  Copyright © 2020 Devshop7. All rights reserved.
//


import UIKit
import CoreLocation
import Photos
import AVFoundation

class ExperienceViewController: UIViewController {
    

    
    @IBOutlet weak var playAudioButton: UIButton!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    @IBOutlet weak var chooseImageButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var recordAudioButton: UIButton!
    
    
    var experienceController: ExperienceController?
    let locationController = LocationController()
    
    private let noirFilter = CIFilter(name: "CIPhotoEffectNoir")!
    private let context = CIContext(options: nil)
    
    var audioPlayer: AVAudioPlayer?
    var audioRecorder: AVAudioRecorder?
    var audioURL: URL?
    var isPlaying: Bool {
        return audioPlayer?.isPlaying ?? false
    }
    var isRecording: Bool {
        return audioRecorder?.isRecording ?? false
    }
    
    var videoURL: URL?

    override func viewDidLoad() {
        super.viewDidLoad()

        titleTextField.delegate = self
        locationController.delegate = self
        
        updateViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        deletePreviousVideoRecording()
    }
    
    
    private func updateViews() {
        nextButton.isEnabled = !(titleTextField.text?.isEmpty ?? true)
        
        chooseImageButton.isHidden = imageView.image != nil
        
        recordAudioButton.isSelected = isRecording
        playAudioButton.isSelected = isPlaying
    }
    
    private func presentImagePickerController() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func deletePreviousAudioRecording() {
        let fileManager = FileManager.default
        
        do {
            if let recordURL = audioURL {
                try fileManager.removeItem(at: recordURL)
                self.audioURL = nil
            }
        } catch {
            NSLog("Error deleting previous audio recording: \(error)")
        }
    }
    
    private func deletePreviousVideoRecording() {
        let fileManager = FileManager.default
        
        do {
            if let recordURL = videoURL {
                try fileManager.removeItem(at: recordURL)
                self.videoURL = nil
            }
        } catch {
            NSLog("Error deleting previous video recording: \(error)")
        }
    }
    
    private func record() {
        let fileManager = FileManager.default
        
      
        deletePreviousAudioRecording()
        
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let name = ISO8601DateFormatter.string(from: Date(), timeZone: .current, formatOptions: [.withInternetDateTime])
        let file = documentsDirectory
            .appendingPathComponent(name)
            .appendingPathExtension("caf")
        
        print(file)
        
       
        let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1)!
        audioRecorder = try! AVAudioRecorder(url: file, format: format)
        audioURL = file
        audioRecorder?.delegate = self
        audioRecorder?.record()
        updateViews()
    }
    
    private func stopRecording() {
        audioRecorder?.stop()
        updateViews()
    }
    
    func recordToggle() {
        if isRecording {
            stopRecording()
        } else {
            record()
        }
    }
    
    private func play() {
        audioPlayer?.play()
        updateViews()
    }
    
    private func stopPlayback() {
        audioPlayer?.stop()
        updateViews()
    }
    
    private func playToggle() {
        if isPlaying {
            stopPlayback()
        } else {
            play()
        }
    }
    
    
    @IBAction func recordAudio(_ sender: UIButton) {
        recordToggle()
    }
    
    @IBAction func playAudio(_ sender: UIButton) {
        playToggle()
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


    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cameraVC = segue.destination as? CameraViewController {
            cameraVC.experienceController = experienceController
            cameraVC.delegate = self
        }
    }

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
        
        var imageData: Data?
        
        if let image = imageView.image {
            imageData = image.pngData()
        }
        
        experienceController?.createExperience(title: title, coordinate: coordinate, videoURL: videoURL, audioURL: audioURL, imageData: imageData)
        
        audioURL = nil
        videoURL = nil
        
        navigationController?.popToRootViewController(animated: true)
    }
}


extension ExperienceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        guard let cgImage = image.cgImage else { return }
        
        var ciImage = CIImage(cgImage: cgImage)
        
        noirFilter.setValue(ciImage, forKey: "inputImage")
        if let outputCIImage = noirFilter.outputImage {
            ciImage = outputCIImage
        }
        
        let bounds = CGRect(origin: CGPoint.zero, size: image.size)
        guard let outputCGImage = context.createCGImage(ciImage, from: bounds) else { return }
        
        imageView.image = UIImage(cgImage: outputCGImage)
        
        updateViews()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}


extension ExperienceViewController: AVAudioRecorderDelegate {
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let error = error {
            NSLog("Record error: \(error)")
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if let recordURL = audioURL {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: recordURL)
                audioPlayer?.delegate = self
            } catch {
                NSLog("Error loading recorded audio for playback: \(error)")
            }
        }
        updateViews()
    }
}



extension ExperienceViewController: AVAudioPlayerDelegate {
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let error = error {
            NSLog("Playback error: \(error)")
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        updateViews()
    }
}

extension ExperienceViewController: CameraViewControllerDelegate {
    func setRecordURL(_ recordURL: URL) {
        videoURL = recordURL
        locationController.requestLocation()
    }
    
    func saveWithNoVideo() {
        deletePreviousVideoRecording()
        locationController.requestLocation()
    }
}
