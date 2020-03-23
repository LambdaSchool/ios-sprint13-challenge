//
//  AddExperienceViewController.swift
//  Experiences
//
//  Created by Dillon P on 3/22/20.
//  Copyright © 2020 Lambda iOSPT3. All rights reserved.
//

import UIKit
import Photos
import CoreImage
import CoreImage.CIFilterBuiltins
import AVFoundation

class AddExperienceViewController: UIViewController {
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var chooseImageButton: UIButton!
    @IBOutlet weak var recordAudioButton: UIButton!
    
    
    //MARK: - View Set-Up

    override func viewDidLoad() {
        super.viewDidLoad()
        
         audioPlayer = AVAudioPlayer()
    }
    
    private func updateViews() {
        recordAudioButton.isSelected = isRecording
    }
    
    
    // MARK: - Image Properties
    
    var originalImage: UIImage? {
        didSet {
            imageView.image = makeImageBW(byFiltering: originalImage!)
            imageData = imageView.image?.jpegData(compressionQuality: 0.1)
        }
    }
    
    var imageData: Data?
    
    
    //MARK: - Audio Properties
    
    var audioPlayer: AVAudioPlayer? {
        didSet {
            guard let audioPlayer = audioPlayer else { return }
            audioPlayer.delegate = self
            updateViews()
        }
    }
    
    var audioRecorder: AVAudioRecorder?
    var recordingURL: URL?
    
    var isRecording: Bool {
        audioRecorder?.isRecording ?? false
    }
    
    var audioData: Data?
    
    
    //MARK: - Audio Player & Recorder Methods
    
    func createNewRecordingURL() -> URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let name = ISO8601DateFormatter.string(from: Date(), timeZone: .current, formatOptions: .withInternetDateTime)
        let file = documents.appendingPathComponent(name, isDirectory: false).appendingPathExtension("caf")
        
    return file
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
    
        
    func startRecording() {
        // try to prepare audio session
        do {
            try prepareAudioSession()
        } catch {
            print("We could not record audio: \(error)")
            return
        }
        
        recordingURL = createNewRecordingURL()
        
        let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1)!
        
        do {
            audioRecorder = try AVAudioRecorder(url: recordingURL!, format: format)
            audioRecorder?.record()
            audioRecorder?.delegate = self
            updateViews()
        } catch {
            preconditionFailure("The audio recorder could not be created with \(recordingURL!) and \(format)")
        }
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        updateViews()
    }
    
    private func play() {
        do {
            try prepareAudioSession()
            audioPlayer?.play()
            updateViews()
        } catch {
            print("Error preparing audio session: \(error)")
            return
        }
    }

    
    // MARK: - Image Picker Methods
    
    private func presentImagePickerController() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            preconditionFailure("Photo Library not available")
        }
        DispatchQueue.main.async {
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            
            imagePicker.sourceType = .photoLibrary

            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    // MARK: - Image Filtering Methods
    
    private let context = CIContext()
    private let bwFilter = CIFilter.photoEffectMono()
    
    func makeImageBW(byFiltering image: UIImage) -> UIImage {
        // 1. UI Image -> CG Image
        guard let cgImage = image.cgImage else {
            print("Couldn't get CGImage from UIImage input")
            return image
        }
        // 2a. CGImage -> CIImage as filter input
        let inputImage = CIImage(cgImage: cgImage)
        // 2b. Filter CIImage
        bwFilter.inputImage = inputImage
        // 2c. CIImage as filter output
        guard let outputImage = bwFilter.outputImage else {
            print("Unable to get filter output image")
            return image
        }
        // 3. Render filtered output CIImage to a CGImage
        guard let renderedImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            print("Unable to render chrome filtered image")
            return image
        }
        // 4. Return UIImage
        return UIImage(cgImage: renderedImage)
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowCameraViewSegue" {
            guard  let cameraVC = segue.destination as? CameraViewController,
                let audioData = audioData,
                let imageData = imageData,
                let title = titleTextField.text, !title.isEmpty else { return }
            
            cameraVC.title = title
            cameraVC.audioData = audioData
            cameraVC.imageData = imageData
        }
    }
    
    
    // MARK: - Actions
    
    
    @IBAction func choosImageButtonTapped(_ sender: Any) {
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch authorizationStatus {
        case .authorized:
            presentImagePickerController()
        case .notDetermined:
            
            PHPhotoLibrary.requestAuthorization { (status) in
                
                guard status == .authorized else {
                    NSLog("User did not authorize access to the photo library")
                    return
                }
                self.presentImagePickerController()
            }
            
        case .denied:
            let alert = UIAlertController(title: "Error", message: "In order to access the photo library, you must allow this application access to it.", preferredStyle: .alert)
            self.present(alert, animated: true)
        case .restricted:
            let alert = UIAlertController(title: "Error", message: "In order to access the photo library, you must allow this application access to it.", preferredStyle: .alert)
            self.present(alert, animated: true)
        @unknown default:
            break
        }
        presentImagePickerController()
    }
    
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        guard titleTextField.text != nil else { return }
        
        self.performSegue(withIdentifier: "ShowCameraViewSegue", sender: self)
    }
    
    @IBAction func recordAudioButtonTapped(_ sender: Any) {
        
        if isRecording {
            stopRecording()
        } else {
            requestPermissionOrStartRecording()
        }
    }
    
}


//MARK: - Image Picker Delegate Extension

extension AddExperienceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        chooseImageButton.setTitle("", for: .normal)
        
        picker.dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            originalImage = image
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}


//MARK: - Audio Player & Recorder Delegate Extension

extension AddExperienceViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        updateViews()
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let error = error {
            print("Error decoding audio: \(error)")
        }
    }
}

extension AddExperienceViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if let recordingURL = recordingURL {
            audioPlayer = try? AVAudioPlayer(contentsOf: recordingURL)
            do {
                audioData = try Data(contentsOf: recordingURL)
                play()
            } catch {
                print("Error getting audio data: \(error)")
            }
        }
        audioRecorder = nil
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let error = error {
            print("Audio recorder error: \(error)")
        }
    }
}
