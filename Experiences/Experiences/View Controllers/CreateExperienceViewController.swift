//
//  CreateExperienceViewController.swift
//  Experiences
//
//  Created by Joshua Rutkowski on 5/17/20.
//  Copyright © 2020 Josh Rutkowski. All rights reserved.
//

import UIKit
import AVFoundation

class CreateExperienceViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var experienceImageView: UIImageView!
    @IBOutlet var recordAudioButton: UIButton!
    
    //Mark: - Properties
    var experienceController: ExperienceController?
    var experience: Experience?
    var experienceTitle: String?
    var latitude: Double?
    var longitude: Double?
    var audioExtension: String?
    var photoExtension: String?
    var image = ""
    var originalImage: UIImage? {
        didSet {
            savePhoto()
        }
    }
    var audio = ""
    let recordMovieController = RecordMovieViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.delegate = self

        // Do any additional setup after loading the view.
    }
    // MARK: - Image
    
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
        
        experienceImageView.image = UIImage(cgImage: outputCGImage)
        
        return UIImage(cgImage: outputCGImage)
    }
    
    // MARK: - Audio
    
    var audioRecorder: AVAudioRecorder?
    var isRecording: Bool {
        audioRecorder?.isRecording ?? false
    }
    var recordURL: URL?
    
    func record() {
        audioRecorder = nil
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        audio = UUID().uuidString
        
        let file = documentsDirectory.appendingPathComponent(audio).appendingPathExtension("caf")
        print(file) // Testing and it works!
        
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
        let recordButtonTitle = isRecording ? "Stop Recording" : "Record Audio"
        recordAudioButton.setTitle(recordButtonTitle, for: .normal)
    }
    
    // MARK: - Video Permissions
    
    private func requestPermissionAndShowCamera() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .notDetermined:
            requestPermission()
        case .restricted:
            fatalError("Video access is restricted.")
        case .denied:
            fatalError("Permission denied.")
        case .authorized:
            showCamera()
        @unknown default:
            fatalError("No idea why this happened!")
        }
    }
    
    private func requestPermission() {
        AVCaptureDevice.requestAccess(for: .video) { (granted) in
            guard granted else {
                fatalError("Permission was not granted.")
            }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                self.showCamera()
            }
        }
    }
    
    private func showCamera() {
        performSegue(withIdentifier: "ShowRecordVideoSegue", sender: self)
    
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowRecordVideoSegue" {
            guard let VC = segue.destination as? RecordMovieViewController,
                let experienceTitle = experienceTitle,
                let latitude = latitude,
                let longitude = longitude else { return }
            VC.experienceController = experienceController
            
            VC.experienceTitle = experienceTitle
            VC.latitude = latitude
            VC.longitude = longitude
            VC.audioExtension = audioExtension
            VC.photoExtension = photoExtension
        }
    }

    
    //MARK: - IBActions

    @IBAction func addPhotoButtonTapped(_ sender: Any) {
        presentImagePickerController()
    }
    
    @IBAction func recordAudioButtonTapped(_ sender: Any) {
        recordToggle()
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
         saveExperience()
         requestPermissionAndShowCamera()
    }
    
    func saveExperience() {
        guard let title = titleTextField.text,
            !title.isEmpty else { return }
        
        experienceTitle = title
        latitude = lat()
        longitude = long()
        audioExtension = audio
        photoExtension = image
    }
    
    // Random lat/long. "Should" be Maryland/East Coast area...
    func lat() -> Double {
        return Double(Int.random(in: 39_299_236...40_000_000)) / 1_000_000
    }
    
    func long() -> Double {
        return Double(Int.random(in: (-076_609_383)...(-121_963_246))) / 1_000_000
    }
    
    
}

//MARK: - Extensions
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
