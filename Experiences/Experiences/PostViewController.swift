//
//  PostViewController.swift
//  Experiences
//
//  Created by Julian A. Fordyce on 3/29/19.
//  Copyright © 2019 Julian A. Fordyce. All rights reserved.
//

import Foundation
import UIKit
import Photos
import MapKit
import AVFoundation

class PostViewController: UIViewController {
    
    
    override func viewDidLoad() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    
}
    
    @IBAction func addImage(_ sender: Any) {
         showImagePicker()
        
    }
    
    private func showImagePicker() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            NSLog("Photo library is not available")
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    private func filterImage() {
        guard let image = originalImage else { return }
        guard let cgImage = image.cgImage else { return }
        
        let ciImage = CIImage(cgImage: cgImage)
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        
        guard let outputCIImage = filter.outputImage else { return }
        guard let outputCGImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) else { return }
        
        let filteredImage = UIImage(cgImage: outputCGImage)
        self.image = filteredImage
        imageView.image = filteredImage
    }
    
    @IBAction func segueToCamera(_ sender: Any) {
        guard let title = titleTextField.text,
            let image = image,
            let audio = audio,
            let coordinate = coordinate else { return }
        
        let newExperience = experienceController?.beginExperience(title: title, coordinate: coordinate, image: image, audio: audio)
        
        self.newExperience = newExperience
        
      
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                performSegue(withIdentifier: "ShowVideoCamera", sender: self)
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { (granted) in
                    if granted { self.performSegue(withIdentifier: "ShowVideoCamera", sender: self) }
                    
                    NSLog("VideoFilters needs video capture access.")
                }
            case .denied, .restricted:
                NSLog("VideoFilters needs video capture access.")
            }
        
    }
    
    
    
    @IBAction func recordAudio(_ sender: Any) {
        
        defer { updateViews() }
        
        guard !isRecording else {
            recorder?.stop()
            return
        }
        
        do {
            let format = AVAudioFormat(standardFormatWithSampleRate: 44100.0, channels: 2)!
            recorder = try AVAudioRecorder(url: newRecordingURL(), format: format)
            recorder?.delegate = self
            recorder?.record()
        } catch {
            NSLog("Error starting recording: \(error)")
        }
    }
    
    private func newRecordingURL() -> URL {
        let documentsDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        return documentsDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("caf")
    }
    
    
    func updateViews() {
        let recordButtonTitle = isRecording ? "Stop" : "Record Audio"
        recordButton.setTitle(recordButtonTitle, for: .normal)
    }
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Properties
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var recordButton: UIButton!

    
    
    private let filter = CIFilter(name: "CIPhotoEffectChrome")!
    private let context = CIContext(options: nil)
    
    private var isRecording: Bool {
        return recorder?.isRecording ?? false
    }
    private var recorder: AVAudioRecorder?
    var mapView: MKMapView?
    var coordinate: CLLocationCoordinate2D?
    var audio: URL?
    var image: UIImage?
    var newExperience: Experience?
    var experienceController: ExperienceController?
    private var originalImage: UIImage? {
        didSet {
            filterImage()
        }
        
    }
}

extension PostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        
        originalImage = image
        
        picker.dismiss(animated: true, completion: nil)

    }
    
}

extension PostViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        self.audio = recorder.url
        self.recorder = nil
        updateViews()
    }
}
