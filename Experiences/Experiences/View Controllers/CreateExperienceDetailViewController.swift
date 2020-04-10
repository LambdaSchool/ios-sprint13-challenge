//
//  CreateExperienceDetailViewController.swift
//  Experiences
//
//  Created by scott harris on 4/10/20.
//  Copyright © 2020 scott harris. All rights reserved.
//

import UIKit
import CoreImage.CIFilterBuiltins
import AVFoundation
import CoreLocation

class CreateExperienceDetailViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var audioRecordButton: UIButton!
    
    private var context = CIContext(options: nil)
    var audioRecorder: AVAudioRecorder?
    var recordingURL: URL?
    let locationManager = Location()
    var location: CLLocation?
    var experienceController: ExperienceController?
    
    var isRecording: Bool {
        audioRecorder?.isRecording ?? false
    }
    
    private var originalImage: UIImage? {
        didSet {
            let image = filterImage(originalImage!)
            imageView.image = image
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "New Experience"
        self.location = locationManager.getCurrentLocation()
    }
    
    @IBAction func addPhotoTapped(_ sender: Any) {
        addPhotoButton.isHidden = true
        
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("Error: The photo library is not available")
            return
        }
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
 
    }
    
    @IBAction func recordAudioTapped(_ sender: Any) {
        if isRecording {
            stopRecording()
        } else {
            requestPermissionOrStartRecording()
        }
        
        updateViews()
    }
    
    func createNewRecordingURL() -> URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
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
        let recordingURL = createNewRecordingURL()
        
        let audioFormat = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1)!
        audioRecorder = try? AVAudioRecorder(url: recordingURL, format: audioFormat)
        audioRecorder?.delegate = self
        audioRecorder?.record()
        
        updateViews()
        
        self.recordingURL = recordingURL
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        updateViews()
    }
    
    private func updateViews() {
        audioRecordButton.isSelected = isRecording
    }
    
    
    func filterImage(_ image: UIImage) -> UIImage? {
        guard let cgImage = image.cgImage else { return nil }
        let ciImage = CIImage(cgImage: cgImage)
        
        let filter = CIFilter.colorControls()
        filter.inputImage = ciImage
        filter.saturation = 0.0
        
        guard let outputCIImage = filter.outputImage else { return nil }
        guard let outputCGImage = context.createCGImage(outputCIImage, from: CGRect(origin: .zero, size: image.size)) else { return nil }
        
        return UIImage(cgImage: outputCGImage)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RecordVideoShowSegue" {
            if let destVC = segue.destination as? ExperienceVideoViewController {
                destVC.experienceTitle = titleTextField.text
                destVC.experiencAudioRecordingURL = recordingURL
                destVC.experienceImage = imageView.image
                destVC.location = location
                destVC.experienceController = experienceController
            }
        }
    }
    
}

extension CreateExperienceDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
           originalImage = image
        }
        
        picker.dismiss(animated: true)
    }
}

extension CreateExperienceDetailViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        updateViews()
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let error = error {
            print("Audio recorder error: \(error)")
        }
        updateViews()
    }
}
