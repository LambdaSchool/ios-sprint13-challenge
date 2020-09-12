//
//  NewExperienceViewController.swift
//  Experiences
//
//  Created by Bronson Mullens on 9/11/20.
//  Copyright © 2020 Bronson Mullens. All rights reserved.
//

import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins
import AVFoundation
import MapKit
import Photos

class NewExperienceViewController: UIViewController {
    
    // MARK: - Properties
    
    var experienceController: ExperienceController?
    var coordinates: CLLocationCoordinate2D?
    var image: UIImage?
    var audioURL: URL?
    
    let context = CIContext(options: nil)
    
    // Audio Properties
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    var recordURL: URL?
    var finishedAudioURL: URL?
    
    var isRecording: Bool {
        return audioRecorder?.isRecording ?? false
    }
    
    var isPlaying: Bool {
        audioPlayer?.isPlaying ?? false
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var experienceTitle: UITextField!
    @IBOutlet weak var experienceImage: UIImageView!
    @IBOutlet weak var recordAudioButton: UIButton!
    
    // MARK: - IBActions
    
    @IBAction func addImageButtonTapped(_ sender: UIButton) {
        presentImagePicker()
    }
    
    @IBAction func saveExperienceButtonTapped(_ sender: UIBarButtonItem) {
        guard let title = experienceTitle.text, !title.isEmpty,
            let coordinates = coordinates,
            let image = image ,
            let audioURL = audioURL else {
                NSLog("Could not save new experience. Missing a property.")
                return
        }
        experienceController?.createExperience(title: title, coordinate: coordinates, image: image, audioURL: audioURL)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func recordAudioButtonTapped(_ sender: UIButton) {
        if recordAudioButton.currentTitle == "Record Audio" {
            // Sets button to a recording state
            recordAudioButton.setTitle("Stop Recording", for: .normal)
            recordAudioButton.tintColor = .systemRed
            
            startRecording()
        } else {
            // Return buton to normal state
            recordAudioButton.setTitle("Record Audio", for: .normal)
            recordAudioButton.tintColor = .systemBlue
            
            stopRecording()
        }
    }
    
    @IBAction func playRecordedAudioButtonTapped(_ sender: UIButton) {
        // Plays back recorded audio
        if isPlaying {
            pauseRecording()
        } else {
            playRecording()
        }
        
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Methods
    
    private func presentImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        let alert = UIAlertController(title: "Choose an option", message: nil, preferredStyle: .actionSheet)
        
        let cameraOption = UIAlertAction(title: "Camera", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            } else {
                NSLog("Camera is unavailable")
            }
        }
        
        let photoLibraryOption = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            } else {
                NSLog("Photo Library is unavailable")
            }
        }
        
        let cancelOption = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cameraOption)
        alert.addAction(photoLibraryOption)
        alert.addAction(cancelOption)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func filterChosenImage(_ image: UIImage) -> UIImage? {
        guard let cgImage = image.cgImage else { return nil }
        
        // Set filter here
        let filter = CIFilter.colorMonochrome()
        
        let ciImage = CIImage(cgImage: cgImage)
        filter.inputImage = ciImage
        
        guard let outputCIImage = filter.outputImage,
            let outputCGImage = context.createCGImage(outputCIImage, from: CGRect(origin: .zero, size: image.size)) else { return nil }
        
        return UIImage(cgImage: outputCGImage)
    }
    
    func prepareAudioSession() throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playAndRecord, options: [.defaultToSpeaker])
        try session.setActive(true, options: []) // can fail if on a phone call, for instance
    }
    
    func createNewRecordingURL() -> URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let name = ISO8601DateFormatter.string(from: Date(), timeZone: .current, formatOptions: .withInternetDateTime)
        let url = documents.appendingPathComponent(name, isDirectory: false).appendingPathExtension("caf")
        
        print("Recording URL: \(url)")
        
        return url
    }
    
    func startRecording() {
        do {
            try prepareAudioSession()
        } catch {
            NSLog("Could not record audio")
            return
        }
        
        audioURL = createNewRecordingURL()
        
        let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1)!
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioURL!, format: format)
            audioRecorder?.delegate = self
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.record()
        } catch {
            preconditionFailure("The audio recorder could not be created with \(audioURL!) and \(format)")
        }
    }
    
    func stopRecording() {
        audioRecorder?.stop()
    }
    
    func playRecording() {
        do {
            try prepareAudioSession()
            audioPlayer?.play()
        } catch {
            NSLog("Could not play recorded audio")
        }
    }
    
    func pauseRecording() {
        audioPlayer?.pause()
    }
    
    // MARK: - Navigation
    
    // Implement if completing video support stretch goal
    
}

extension NewExperienceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let filteredImage = filterChosenImage(image)
        
        self.image = filteredImage
        experienceImage.image = filteredImage
        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension NewExperienceViewController: AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if let audioURL = audioURL {
            audioPlayer = try? AVAudioPlayer(contentsOf: audioURL)
        }
        // audioURL = nil
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if error != nil {
            NSLog("Error occured during audio playback")
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        NSLog("Finished playing audio")
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if error != nil {
            NSLog("Error occured during audio playback")
        }
    }
    
}
