//
//  ExperiencesViewController.swift
//  Experiences
//
//  Created by Jesse Ruiz on 12/6/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import Photos
import AVFoundation

class ExperiencesViewController: UIViewController {
    
    // MARK: - Properties
    var originalImage: UIImage?
    let context = CIContext(options: nil)
    var imageData: Data?
    
    // MARK: - Outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var videoPlayerView: VideoContainerView!
    @IBOutlet weak var addFilterButton: UIButton!
    @IBOutlet weak var addVideoButton: UIButton!
    @IBOutlet weak var chooseImageButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
    }
    
    func updateViews() {
        guard imageView.image == nil else { return }
        addFilterButton.isHidden = true
        
        let playButtonTitle = isPlaying ? "Pause" : "Play"
        playButton.setTitle(playButtonTitle, for: .normal)
        
        let recordButtonTitle = isRecording ? "Stop Recording" : "Record"
        recordButton.setTitle(recordButtonTitle, for: .normal)
    }
    
    // MARK: - Actions
    @IBAction func addImage(_ sender: UIButton) {
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
        default:
            break
        }
        presentImagePickerController()
    }
    
    func presentInformationalAlertController(title: String?, message: String?, dismissActionCompletion: ((UIAlertAction) -> Void)? = nil, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: dismissActionCompletion)
        
        alertController.addAction(dismissAction)
        
        present(alertController, animated: true, completion: completion)
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
    
    enum ImageFilter: String {
        case fade = "CIPhotoEffectFade"
        case chrome = "CIPhotoEffectChrome"
        case instant = "CIPhotoEffectInstant"
        case noir = "CIPhotoEffectNoir"
        case none
        
        static var allFilters: [ImageFilter] = [.fade]
    }
    
    @IBAction func addFilter(_ sender: UIButton) {
        let alert = UIAlertController(title: "Add a filter", message: nil, preferredStyle: .actionSheet)
        
        let fadeAction = UIAlertAction(title: "Fade", style: .default) { (_) in
            self.filterImage(withFilter: .fade)
        }
        let chromeAction = UIAlertAction(title: "Chrome", style: .default) { (_) in
            self.filterImage(withFilter: .chrome)
        }
        let instantAction = UIAlertAction(title: "Instant", style: .default) { (_) in
            self.filterImage(withFilter: .instant)
        }
        let noirAction = UIAlertAction(title: "Noir", style: .default) { (_) in
            self.filterImage(withFilter: .noir)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(fadeAction)
        alert.addAction(chromeAction)
        alert.addAction(instantAction)
        alert.addAction(noirAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func filterImage(withFilter filter: ImageFilter, parameters: [String: CGFloat] = [:]) {
        
        guard let image = originalImage else { return }
        
        if let imageFilter = CIFilter(name: filter.rawValue) {
            
            let startImage = CIImage(image: image)
            imageFilter.setValue(startImage, forKey: kCIInputImageKey)
            
            for (key, value) in parameters {
                imageFilter.setValue(value, forKey: key)
            }
            
            guard let outputImage = imageFilter.outputImage,
                let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
            
            let image = UIImage(cgImage: cgImage)
            
            imageView.image = image
        }
    }
    
    @IBAction func saveExperience(_ sender: UIBarButtonItem) {
        view.endEditing(true)
        
        
        DispatchQueue.main.async {
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - Video
    
    @IBAction func addVideo(_ sender: UIButton) {
        requestPermissionAndShowCamera()
    }
    
    private func requestPermissionAndShowCamera() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
            
        case .notDetermined: // First time user has seen the dialog, we don't have per
            requestPermission()
        case .restricted: // Parental Controler
            fatalError("Video is disabled for parental controls")
        case .denied: // User said no or accidental no
            fatalError("Tell user they need to enable Privacy for Video/Camera")
        case .authorized: // User said yes
            showCamera()
        @unknown default:
            fatalError("A new status was added that we need to handle")
        }
    }
    
    private func requestPermission() {
        AVCaptureDevice.requestAccess(for: .video) { (granted) in
            guard granted else {
                fatalError("Tell user they need to enable Privacy for Video/Camera")
            }
            DispatchQueue.main.async { [weak self] in
                self?.showCamera()
            }
        }
    }
    private func showCamera() {
        //performSegue(withIdentifier: "AddVideo", sender: self)
    }

    // MARK: - Audio
    
    var audioPlayer: AVAudioPlayer?
    var audioRecorder: AVAudioRecorder?
    var isPlaying: Bool {
        audioPlayer?.isPlaying ?? false
    }
    var isRecording: Bool {
        audioRecorder?.isRecording ?? false
    }
    var recordURL: URL?
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    @IBAction func recordButtonPressed(_ sender: UIButton) {
        recordToggle()
    }
    
    func recordToggle() {
        if isRecording {
            stopRecording()
        } else {
            record()
        }
    }
    
    func record() {
        // Path to save in the Documents directory
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        // Filename (ISO8601 format for time) .caf (Core Audio File)
        let name = ISO8601DateFormatter.string(from: Date(), timeZone: .current, formatOptions: [.withInternetDateTime])
        
        let file = documentsDirectory.appendingPathComponent(name).appendingPathExtension("caf")
        // 44.1 KHz
        
        print("Record URL: \(file)")
        let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1)!
        
        // Start a recording
        audioRecorder = try! AVAudioRecorder(url: file, format: format)
        recordURL = file
        audioRecorder?.delegate = self
        audioRecorder?.record()
        updateViews()
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        audioRecorder = nil
        updateViews()
    }
    
    @IBAction func playbuttonPressed(_ sender: UIButton) {
        playToggle()
    }
    
    func playToggle() {
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension ExperiencesViewController: AVAudioPlayerDelegate {
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let error = error {
            print("Audio playback error: \(error)")
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        updateViews()  // TODO: Is this on the main thread?
    }
}

extension ExperiencesViewController: AVAudioRecorderDelegate {
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let error = error {
            print("Record error: \(error)")
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("Recording finished")
        // TODO: Create player with new file URL
        
        if let recordURL = recordURL {
            audioPlayer = try! AVAudioPlayer(contentsOf: recordURL)
        }
    }
}

extension ExperiencesViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        chooseImageButton.setTitle("", for: [])
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        imageView.image = image
        originalImage = image
        
        addFilterButton.isHidden = false
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
