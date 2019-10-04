//
//  ImageAudioViewController.swift
//  Experiences
//
//  Created by Michael Stoffer on 10/3/19.
//  Copyright © 2019 Michael Stoffer. All rights reserved.
//

import UIKit
import AVFoundation

class ImageAudioViewController: UIViewController {
    
    // MARK: - Outlets and Properties
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var addImageButton: UIButton!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var recordButton: UIButton!
    
    var experienceController: ExperienceController?
    
    var originalImage: UIImage? {
        didSet {
            self.updateImage()
        }
    }
    var imageData: Data?
    private let context = CIContext(options: nil)
    private let filter = CIFilter(name: "CISepiaTone")!
    
    private var recordingURL: URL?
    private var recorder: AVAudioRecorder?
    private var isRecording: Bool {
        return recorder?.isRecording ?? false
    }
    
    // MARK: - Actions and Methods
    
    @IBAction func addImageButtonTapped(_ sender: UIButton) {
        self.presentImagePickerController()
    }
    
    @IBAction func recordButtonTapped(_ sender: UIButton) {
        defer { updateRecordButton() }
        
        guard !isRecording else { recorder?.stop(); return }
        
        do {
            let format = AVAudioFormat(standardFormatWithSampleRate: 44100.0, channels: 2)!
            recorder = try AVAudioRecorder(url: self.newRecordingURL(), format: format)
            recorder?.delegate = self
            recorder?.record()
        } catch {
            NSLog("Unable to start recording: \(error)")
            return
        }
    }
    
    private func presentImagePickerController() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { NSLog("The photo library is not available"); return }
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    private func updateImage() {
        if let img = self.originalImage {
            imageView.image = self.image(byFiltering: img)
        } else {
            imageView.image = nil
        }
    }
    
    private func image(byFiltering image: UIImage) -> UIImage {
        guard let cgImage = image.cgImage else { return image }
        let ciImage = CIImage(cgImage: cgImage)
        
        // Set the values of the filter's parameters
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        filter.setValue(0.8, forKey: kCIInputIntensityKey)
        
        // The metadata to be processed. NOT the actual filtered image
        guard let outputCIImage = filter.outputImage else { return image }
        guard let outputCGImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) else { return image }
        let filteredImage = UIImage(cgImage: outputCGImage)
        
        let imageData = filteredImage.jpegData(compressionQuality: 1)!
        self.imageData = imageData
                
        return filteredImage
    }
    
    private func updateRecordButton() {
        let recordButtonString = self.isRecording ? "Stop Recording" : "Record"
        self.recordButton.setTitle(recordButtonString, for: .normal)
    }
    
    private func newRecordingURL() -> URL {
        let fm = FileManager.default
        let documentsDirectory = try! fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        return documentsDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("caf")
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToAddVideo" {
            guard let experienceTitle = self.titleTextField.text,
                let videoVC = segue.destination as? VideoViewController else { return }
            videoVC.experienceController = self.experienceController
            videoVC.experienceTitle = experienceTitle
            videoVC.imageData = self.imageData
            videoVC.audioRecordingURL = self.recordingURL
        }
    }
}

extension ImageAudioViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let img = info[.originalImage] as? UIImage {
            self.originalImage = img
        }
        
        self.addImageButton.isHidden = true
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension ImageAudioViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        self.recordingURL = recorder.url
        self.recorder = nil
        self.updateRecordButton()
    }
}
