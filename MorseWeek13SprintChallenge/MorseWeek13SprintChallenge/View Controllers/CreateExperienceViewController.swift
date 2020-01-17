//
//  CreateExperienceViewController.swift
//  MorseWeek13SprintChallenge
//
//  Created by morse on 1/17/20.
//  Copyright © 2020 morse. All rights reserved.
//

import UIKit
import AVFoundation

class CreateExperienceViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Properties
    
    var experinceController: ExperienceController?
    var experience: Experience?
    var audio = ""
    var image = ""
    var originalImage: UIImage? {
        didSet {
            savePhoto()
        }
    }
    var experienceTitle: String?
    var latitude: Double?
    var longitude: Double?
    var audioExtension: String?
    var photoExtension: String?
    
    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField.delegate = self
    }
    
    // MARK: - Actions
    
    @IBAction func addPhotoButtonTapped(_ sender: Any) {
        presentImagePickerController()
    }
    
    @IBAction func recordAudioButtonTapped(_ sender: Any) {
        recordToggle()
    }
    
    @IBAction func addVideoButtonTapped(_ sender: Any) {
        prepareExperience()
        print(experinceController?.experiences.count)
        requestPermissionAndShowCamera()
    }
    
    func prepareExperience() {
        guard let title = titleTextField.text,
            !title.isEmpty else { return }
        
        experienceTitle = title
        latitude = lat()
        longitude = long()
        audioExtension = audio
        photoExtension = image
    }
    
    func lat() -> Double {
        return Double(Int.random(in: 47_200_953...48_083_626)) / 1_000_000
    }
    
    func long() -> Double {
        return Double(Int.random(in: (-122_564_484)...(-121_963_246))) / 1_000_000
    }
    
    // MARK: - Alerts
    
    private func presentImagePickerController() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("Error: photo library is not available")
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - Audio
    
    var audioRecorder: AVAudioRecorder?
    var isRecording: Bool {
        audioRecorder?.isRecording ?? false
    }
    var recordURL: URL?
    
    func record() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        audio = UUID().uuidString
        
        let file = documentsDirectory.appendingPathComponent(audio).appendingPathExtension("caf")
        
        let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1)!
        
        audioRecorder = try! AVAudioRecorder(url: file, format: format)
        recordURL = file
        audioRecorder?.delegate = self
        audioRecorder?.record()
        updateAudioViews()
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        audioRecorder = nil
        updateAudioViews()
    }
    
    func recordToggle() {
        if isRecording {
            stopRecording()
        } else {
            record()
        }
    }
    
    func updateAudioViews() {
        let recordButtonTitle = isRecording ? "Stop Recording" : "Record New Audio"
        recordButton.setTitle(recordButtonTitle, for: .normal)
    }
    
    // MARK: - Image
    
    func savePhoto() {
        guard let originalImage = originalImage else { return }
        
        let processedImage = filterImage(originalImage)
        
        guard let imageData = processedImage.pngData() else { return }
        
        self.image = UUID().uuidString
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(image).appendingPathExtension("png")
        
        try? imageData.write(to: fileURL)
    }
    
    private func filterImage(_ image: UIImage) -> UIImage {
        
        let filter = CIFilter(name: "CIHueAdjust")!
        let context = CIContext(options: nil)
        
        guard let cgImage = image.cgImage else { return image }
        
        let ciImage = CIImage(cgImage: cgImage)
        
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        filter.setValue(Float(3.141592653589793), forKey: kCIInputAngleKey)
        
        guard let outputCIImage = filter.outputImage else { return image }
        
        guard let outputCGImage = context.createCGImage(outputCIImage, from: CGRect(origin: CGPoint.zero, size: image.size)) else { return image }
        
        imageView.image = UIImage(cgImage: outputCGImage)
        
        return UIImage(cgImage: outputCGImage)
    }
    
    // MARK: - Video Permissions
    
    private func requestPermissionAndShowCamera() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .notDetermined:
            requestPermission()
        case .restricted:
            fatalError("No video")
        case .denied:
            fatalError("Denied!")
        case .authorized:
            showCamera()
        @unknown default:
            fatalError("New case!")
        }
    }
    
    private func requestPermission() {
        AVCaptureDevice.requestAccess(for: .video) { (granted) in
            guard granted else {
                fatalError("No permission")
            }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                self.showCamera()
            }
        }
    }
    
    private func showCamera() {
        performSegue(withIdentifier: PropertyKeys.recordVideoSegue, sender: self)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == PropertyKeys.recordVideoSegue {
            guard let recordVC = segue.destination as? RecordMovieViewController,
                let experienceTitle = experienceTitle,
                let latitude = latitude,
                let longitude = longitude else { return }
            recordVC.experienceController = experinceController
            
            recordVC.experienceTitle = experienceTitle
            recordVC.latitude = latitude
            recordVC.longitude = longitude
            recordVC.audioExtension = audioExtension
            recordVC.photoExtension = photoExtension
        }
    }

}

// MARK: - Extensions

extension CreateExperienceViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}

extension CreateExperienceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.editedImage] as? UIImage {
            originalImage = image
        } else if let image = info[.originalImage] as? UIImage {
            originalImage = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension CreateExperienceViewController: AVAudioRecorderDelegate {
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let error = error {
            print("Record error: \(error)")
        }
    }
}
