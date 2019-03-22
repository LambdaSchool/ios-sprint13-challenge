//
//  PhotoAudioViewController.swift
//  Experiences
//
//  Created by Moses Robinson on 3/22/19.
//  Copyright © 2019 Moses Robinson. All rights reserved.
//

import UIKit
import CoreImage
import Photos
import AVFoundation

class PhotoAudioViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVAudioRecorderDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "New Experience"
    }
    
    @IBAction func addPhoto(_ sender: Any) {
        presentImagePicker()
    }
    
    @IBAction func record(_ sender: Any) {
        
        if isRecording {
            recorder?.stop()
            return
        }
        
        do {
           
            let format = AVAudioFormat(standardFormatWithSampleRate: 44100.0, channels: 2)!
            
            recorder = try AVAudioRecorder(url: newRecordingURL(), format: format)
            recorder?.delegate = self
            recorder?.record()
        } catch {
            NSLog("Unable to start recording")
        }
        
        updateButton()
    }
    
    @IBAction func moveToVideoRecording(_ sender: Any) {
        
        guard let title = titleTextField.text, !title.isEmpty, let image = self.scaledImage, let recordingURL = recordingURL else { return }
        let filteredImage = self.image(byFiltering: image)
        
        experienceController?.title = title
        experienceController?.image = filteredImage
        experienceController?.audioURL = recordingURL
        
        performSegue(withIdentifier: "RecordVideo", sender: nil)
    }
    
    // MARK: Photo Upload
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            originalImage = image
        }

        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    private func presentImagePicker() {
        
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            NSLog("The Photo library is not available on this device.")
            // Present a good alert to the user here in a real app
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func updateImage() {
        if let scaledImage = scaledImage {
            addPhotoButton.isHidden = true
            imageView.image = image(byFiltering: scaledImage)
        }
    }
    
    private func image(byFiltering image: UIImage) -> UIImage {
        
        guard let cgImage = image.cgImage else { return image }
        
        let ciImage = CIImage(cgImage: cgImage)
        
        filter.setValue(ciImage, forKey: "inputImage")
        
        guard let outputCIImage = filter.outputImage, let outputCGImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) else { return image }
        
        return UIImage(cgImage: outputCGImage)
    }
    
    // MARK: Audio Recording
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        updateButton()
        
        recordingURL = recorder.url
    }
    
    private func updateButton() {
        
        let recordButtonTitle = isRecording ? "Stop Recording" : "Record"
        recordButton.setTitle(recordButtonTitle, for: .normal)
    }
    
    private func newRecordingURL() -> URL {
        
        let documentsDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        return documentsDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("caf")
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RecordVideo" {
            guard let destination = segue.destination as? VideoViewController else { return }
            
            destination.experienceController = experienceController
        }
    }
    
    // MARK: - Properties
    
    var experienceController: ExperienceController?
    
    let context = CIContext(options: nil)
    
    let filter = CIFilter(name: "CIPhotoEffectFade")!
    
    var originalImage: UIImage? {
        didSet {
            
            guard let originalImage = originalImage else { return }
            let originalSize = imageView.bounds.size
            let deviceScale = UIScreen.main.scale
            let scaledSize = CGSize(width: originalSize.width * deviceScale, height: originalSize.height * deviceScale)
            
            scaledImage = originalImage.imageByScaling(toSize: scaledSize)
        }
    }
    
    var scaledImage: UIImage? {
        didSet {
            updateImage()
        }
    }
    
    var recordingURL: URL?
    
    private var recorder: AVAudioRecorder?
    
    var isRecording: Bool {
        return recorder?.isRecording ?? false
    }
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var addPhotoButton: UIButton!
    @IBOutlet var recordButton: UIButton!
}


extension UIImage {
    func imageByScaling(toSize size: CGSize) -> UIImage? {
        guard let data = pngData(),
            let imageSource = CGImageSourceCreateWithData(data as CFData, nil) else {
                return nil
        }
        
        let options: [CFString: Any] = [
            kCGImageSourceThumbnailMaxPixelSize: max(size.width, size.height) / 2.0,
            kCGImageSourceCreateThumbnailFromImageAlways: true
        ]
        
        return CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options as CFDictionary).flatMap { UIImage(cgImage: $0) }
    }
}
