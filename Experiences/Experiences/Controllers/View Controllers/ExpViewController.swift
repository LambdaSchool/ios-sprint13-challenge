//
//  ExpViewController.swift
//  Experiences
//
//  Created by Aaron Cleveland on 3/13/20.
//  Copyright © 2020 Aaron Cleveland. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation
import CoreLocation

class ExpViewController: UIViewController, UITextFieldDelegate {
    
    var expController: ExpController!
    let locationManager = CLLocationManager()
    let context = CIContext(options: nil)
    var id: String!
    var recordCount = 0
    var audioHasBeenRecorded = false
    var recorder: AVAudioRecorder?
    var player: AVAudioPlayer?
    var recordingURL: URL?
    
    // MARK: - IBOutlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var posterImageButton: UIButton!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var recordAudioButton: UIButton!
    @IBOutlet weak var playRecordingButton: UIButton!
    
    // MARK: - Variables
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocationManager()
        updateButtons()
        titleTextField.delegate = self
        id = UUID().uuidString
    }
    
    // MARK: - IBActions
    @IBAction func addPosterImage(_ sender: Any) {
        presentImagePickerController()
    }
    
    @IBAction func recordAudio(_ sender: Any) {
        recordAudio()
    }
    
    @IBAction func playAudioRecording(_ sender: Any) {
        playAudio()
    }
    
    // MARK: - Helper Functions
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RecordVideo" {
            
            guard let title = titleTextField.text,
                let image = posterImageView.image,
                let coordinate = locationManager.location?.coordinate,
                let destinationVC = segue.destination as? VideoViewController else { return }
            
            let experience = expController.createExp(title: title, image: image, coordinate: coordinate, id: id)
            
            destinationVC.experience = experience
            destinationVC.expController = expController
        }
    }
}

extension ExpViewController: CLLocationManagerDelegate {
    
    func setUpLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
            
        case .notDetermined:
            
            locationManager.requestWhenInUseAuthorization()
            
        case .authorizedWhenInUse:
            
            locationManager.requestLocation()
            
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NSLog("Location manager failed with error: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else { return }
        
        locationManager.requestLocation()
    }
}

extension ExpViewController: AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    var isPlaying: Bool { return player?.isPlaying ?? false }
    var isRecording: Bool { return recorder?.isRecording ?? false }
    
    func recordAudio() {
        defer { updateButtons() }
        
        guard !isRecording else {
            recorder?.stop()
            return
        }
        
        do {
            let format = AVAudioFormat(standardFormatWithSampleRate: 44100.0, channels: 2)!
            recorder = try AVAudioRecorder(url: newRecordingURL(), format: format)
            recorder?.prepareToRecord()
            recorder?.delegate = self
            recorder?.record()
            recordCount += 1
        } catch {
            NSLog("Unable to start recording: \(error)")
        }
    }
    
    func playAudio() {
        defer { updateButtons() }
        guard let url = recordingURL else {
            return
        }
        
        guard !isPlaying else {
            player?.stop()
            return
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.delegate = self
            player?.play()
        } catch {
            NSLog("Unable to start playing: \(error)")
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        recordingURL = recorder.url
        updateButtons()
        self.recorder = nil
        recordCount += 1
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        updateButtons()
        self.player = nil
    }
    
    private func newRecordingURL() -> URL {
        let fm = FileManager.default
        let documentsDir = try! fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        return documentsDir.appendingPathComponent(id).appendingPathExtension("caf")
    }
    
    func updateButtons() {
        let playButtonTitle = isPlaying ? "Stop Playing" : "Play"
        var recordButtonTitle = isRecording ? "Stop Recording" : "Record"
        if recordCount == 1 { recordButtonTitle = "Stop Recording" }
        if recordCount == 2 { recordButtonTitle = "Record" }
        
        playRecordingButton.setTitle(playButtonTitle, for: .normal)
        recordAudioButton.setTitle(recordButtonTitle, for: .normal)
    }
}

extension ExpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentImagePickerController() {
        
        let alert = UIAlertController(title: "Select Source", message: nil, preferredStyle: .actionSheet)
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (_) in
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            }
            alert.addAction(photoLibraryAction)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { (_) in
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            }
            alert.addAction(cameraAction)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.originalImage] as? UIImage else { return }
        let processedImage = grayscaleImage(image)
        posterImageView.image = processedImage
        picker.dismiss(animated: true, completion: nil)
        posterImageButton.setTitle("", for: .normal)
    }
    
    func grayscaleImage(_ image: UIImage) -> UIImage? {
        
        if let imageFilter = CIFilter(name: "CIColorControls") {
            let startImage = CIImage(image: image)
            imageFilter.setValue(startImage, forKey: kCIInputImageKey)
            imageFilter.setValue(1.0, forKey: "inputSaturation")
            guard let outputImage = imageFilter.outputImage,
                let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return nil }
            
            return UIImage(cgImage: cgImage)
        }
        
        return nil
    }
}
