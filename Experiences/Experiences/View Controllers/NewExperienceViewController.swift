//
//  NewExperienceViewController.swift
//  Experiences
//
//  Created by Jake Connerly on 11/1/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import UIKit
import CoreImage
import Photos

class NewExperienceViewController: UIViewController {
    
    // MARK: - IBOutlets & Properties
    
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var imageViewContainer: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var selectImageButton: UIButton!
    @IBOutlet weak var playAudioRecordingButton: UIButton!
    @IBOutlet weak var recordAudioButton: UIButton!
    
    var experienceController: ExperienceController?
    let imagePicker = UIImagePickerController()
    var player: Player = Player(url: nil)
    var recorder: Recorder = Recorder()
    
    var imageToSave: Data?
    var audioRecordingToSave: String?
    
    private let context = CIContext(options: nil)
    private let sepiaFilter = CIFilter(name: "CISepiaTone")!
    
    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        player.delegate = self
        recorder.delegate = self
        playAudioRecordingButton.isHidden = true
    }
    
    //MARK: - Methods
    
    private func filterImage(image: UIImage) -> UIImage? {
        guard let cgImage = image.cgImage else { return nil }
        let ciImage = CIImage(cgImage: cgImage)
        
        sepiaFilter.setValue(ciImage, forKey: "inputImage")
        sepiaFilter.setValue(1.0, forKey: "inputIntensity")
        guard let outputCIImageWithSepia = sepiaFilter.outputImage else { return nil }
        
        guard let outputCGImage = context.createCGImage(outputCIImageWithSepia, from: CGRect(origin: CGPoint.zero, size: image.size)) else { return nil }
        
        return UIImage(cgImage: outputCGImage)
    }
    
    private func presentImagePickerController() {
        
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            presentInformationalAlertController(title: "Error", message: "The photo library is unavailable")
            return
        }
        
        imagePicker.delegate = self
        
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    private func checkVideoAuthorization() {
        
        // AVCaptureDevice
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .notDetermined: // user hasn't made a decision
            // request permission
            requestVideoPermission()
        case .restricted: // Parental controls are disabling video
            fatalError("Present UI to user informing them to enable video to use this app")
        case .denied: // The user said no (might not be intentional, depends on how you ask)
            fatalError("Present UI on how to re-enable video for this app in Settings > Privacy")
        case .authorized: // User said yes, we can use video
            showCamera()
        @unknown default:
            fatalError("AVFoundation unexpected new status code")
        }
    }
    
    private func requestVideoPermission() {
        AVCaptureDevice.requestAccess(for: .video) { (granted) in
            guard granted == true else { fatalError("Present UI on how to enable Settings > Privacy") }
            
            DispatchQueue.main.async {
                self.showCamera()
            }
        }
    }
    
    private func showCamera() {
        if titleTextField.text == "" {
            //throw alert
            return
        }
        checkVideoAuthorization()
        performSegue(withIdentifier: "ShowCamera", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowCamera" {
            guard let cameraVC = segue.destination as? CameraViewController,
                  let audioToSave = audioRecordingToSave,
                  let imageToSave = imageToSave else { return }
            
            cameraVC.experienceController = experienceController
            cameraVC.audioToSave = audioToSave
            cameraVC.imageToSave = imageToSave
            cameraVC.experienceTitle = titleTextField.text
        }
    }
    
    //MARK: - IBActions
    
    @IBAction func selectAnImageTapped(_ sender: UIButton) {
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
    
    @IBAction func recordButtonTapped(_ sender: UIButton) {
        recorder.toggleRecording()
    }
    @IBAction func playAudioRecordingTapped(_ sender: UIButton) {
        player.playPause()
    }
}

// MARK: - Extensions

extension NewExperienceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        selectImageButton.isHidden = true
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        var scaledSize = imageView.bounds.size
        let scale = UIScreen.main.scale
        
        scaledSize = CGSize(width: scaledSize.width * scale, height: scaledSize.height * scale)
        guard let scaledImage = image.imageByScaling(toSize: scaledSize) else { return }
        
        let filteredImage = filterImage(image: scaledImage)
        imageView.image = filteredImage
        if let imageData = filteredImage?.pngData() {
            imageToSave = imageData
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension NewExperienceViewController: RecorderDelegate {
    func recorderDidChangeState(recorder: Recorder) {
        let recordButtonTitle = recorder.isRecording ? "Stop Recording" : "Record Comment"
        recordAudioButton.setTitle(recordButtonTitle, for: .normal)
    }
    
    func recorderDidSaveFile(recorder: Recorder) {
        if let url = recorder.url, recorder.isRecording == false {
            player = Player(url: url)
            player.delegate = self
            playAudioRecordingButton.isHidden = false
            audioRecordingToSave = "\(url)"
        }
    }
}

extension NewExperienceViewController: PlayerDelegate {
    func playerDidChangeState(player: Player) {
        let playButtonTitle = player.isPlaying ? "Pause" : "Play"
        playAudioRecordingButton.setTitle(playButtonTitle, for: .normal)
    }
    
    
}
