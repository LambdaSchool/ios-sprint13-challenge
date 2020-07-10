//
//  AddExperienceViewController.swift
//  Experiences
//
//  Created by Nonye on 7/10/20.
//  Copyright © 2020 Nonye Ezekwo. All rights reserved.
//

import UIKit
import Photos
import AVFoundation

class AddExperienceViewController: UIViewController {
    // MARK: PROPERTIES
    
    private let context = CIContext(options: nil)
    
    var experienceController: ExperienceController?
    var coordinate: CLLocationCoordinate2D?
    
    let imageFilter = CIFilter(name: "CIPhotoEffectInstant")!
    var posterImage: UIImage?
    
    var recordingURL: URL?
    var audioRecorder: AVAudioRecorder?
    
    // MARK: - OUTLETS
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var addImage: UIButton!
    @IBOutlet var recordButton: UIButton!
    @IBOutlet var playButton: UIButton!
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioRecorder?.delegate = self
        hideKeyboardOnTap()
        updateViews()
        try? prepareAudioSession()
        
    }
    
    func updateViews() {
        playButton.isSelected = isPlaying
        
    }
    var originalImage: UIImage? {
        didSet {
            updateImage()
        }
    }
    
    func updateImage() {
        if let originalImage = originalImage {
            
            var scaledSize = imageView.bounds.size
            let scale = UIScreen.main.scale
            scaledSize = CGSize(width: scaledSize.width * scale, height: scaledSize.height * scale)
            
            imageView.image = image(byFiltering: originalImage.imageByScaling(toSize: scaledSize)!)
            
        } else {
            imageView.image = nil
        }
    }
    
    private func image(byFiltering image: UIImage) -> UIImage {
        guard let cgImage = image.cgImage else { return image }
        let ciImage = CIImage(cgImage: cgImage)
        imageFilter.setValue(ciImage, forKey: "inputImage")
        
        guard let outputCIImage = imageFilter.outputImage else { return image }
        
        guard let outputCGImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) else { return image }
        
        return UIImage(cgImage: outputCGImage)
    }
    
    
    // MARK: - Audio Methods
    
    func prepareAudioSession() throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playAndRecord, options: [.defaultToSpeaker])
        try session.setActive(true, options: [])
    }
    
    func loadAudio() {
        let songURL = createNewRecordingURL()
        audioPlayer = try? AVAudioPlayer(contentsOf: songURL)
    }
    
    var isPlaying: Bool {
        return audioPlayer?.isPlaying ?? false
    }
    
    var audioPlayer: AVAudioPlayer? {
        didSet {
            audioPlayer?.delegate = self
        }
    }
    
    func togglePlayback() {
        if isPlaying {
            pause()
        } else {
            play()
        }
    }
    
    func play() {
        audioPlayer?.play()
        updateViews()
    }
    
    func pause() {
        audioPlayer?.pause()
        updateViews()
    }
    
    var isRecording: Bool {
        return audioRecorder?.isRecording ?? false
    }
    
    func toggleRecording() {
        if isRecording {
            stopRecording()
        } else {
            requestPermissionOrStartRecording()
            
        }
    }
    
    private func createNewRecordingURL() -> URL {
        let documents = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let name = ISO8601DateFormatter.string(from: Date(), timeZone: .current, formatOptions: .withInternetDateTime)
        let file = documents.appendingPathComponent(name, isDirectory: false).appendingPathExtension("caf")
        
        print("recording URL: \(file)")
        
        return file
    }
    
    func requestPermissionOrStartRecording() {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                guard granted == true else {
                    print("We need access to the microphone to record a note.")
                    return
                }
            }
        case .denied:
            print("Microphone access has been denied.")
            
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
        let recordingURL = createNewRecordingURL()
        
        //44,1000 hertz = 44.1 kHZ = FM / CD Audio Quality
        let audioFormat = AVAudioFormat(standardFormatWithSampleRate: 44.1, channels: 1)!
        
        audioRecorder = try? AVAudioRecorder(url: recordingURL, format: audioFormat)
        audioRecorder?.delegate = self
        audioRecorder?.record()
        self.recordingURL = recordingURL
        updateViews()
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        updateViews()
    }
    
    // MARK: - ACTIONS
    
    @IBAction func addPosterImageButtonPressed(_ sender: Any) {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("The photo library is unavailable")
            return
        }
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func recordButtonPressed(_ sender: Any) {
        toggleRecording()
    }
    
    @IBAction func playButtonPressed(_ sender: Any) {
        togglePlayback()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RecordSegue" {
            guard let videoVC = segue.destination as? CameraViewController else { return }
            videoVC.experienceController = experienceController
            videoVC.coordinate = coordinate
            videoVC.experienceTitle = titleTextField.text
            videoVC.image = originalImage
            videoVC.audio = recordingURL
        }
    }
    
}

// MARK: - EXTENSION

extension AddExperienceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            originalImage = image
            addImage.isHidden = true
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension AddExperienceViewController: AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        guard let recordingURL = recordingURL else { return }
        print("Finished recording: \(recordingURL.path)")
        audioPlayer = try? AVAudioPlayer(contentsOf: recordingURL)
        updateViews()
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let error = error {
            print("Error recording: \(error)")
        }
        updateViews()
    }
}

extension AddExperienceViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        DispatchQueue.main.async {
            self.updateViews()
        }
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let error = error {
            print(error)
        }
        DispatchQueue.main.async {
            self.updateViews()
        }
    }
}

extension UIViewController {
    internal func hideKeyboardOnTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc private func hideKeyboard() {
        self.view.endEditing(true)
    }
}

