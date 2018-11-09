//
//  NewExperienceViewController.swift
//  Experiences
//
//  Created by Scott Bennett on 11/9/18.
//  Copyright © 2018 Scott Bennett. All rights reserved.
//

import UIKit
import Photos

class NewExperienceViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var audioRecordButton: UIButton!
    @IBOutlet weak var addPosterButton: UIButton!
    
    // MARK: - Properties
    
    private var originalImage: UIImage? {
        didSet {
            updateImage()
        }
    }
    
    private let monoFilter = CIFilter(name: "CIPhotoEffectMono")!
    private let context = CIContext(options: nil)
    
    private var player: AVAudioPlayer?
    private var recorder: AVAudioRecorder?
    
    
    private var isPlaying: Bool {
        return player?.isPlaying ?? false
    }
    
    private var isRecording: Bool {
        return recorder?.isRecording ?? false
    }
    
    private var recordingURL: URL?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "New Experience"

    }
    
    @IBAction func addPosterImageButtonTapped(_ sender: Any) {
        
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            NSLog("The photo library is unavailble")
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func audioRecordButtonTapped(_ sender: Any) {
        
        defer { updateButtons() }
        
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
            NSLog("Recording Fail: \(error)")
        }
        
    }
    
    // MARK: - Audio
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        recordingURL = recorder.url
    }
    
    func updateButtons() {
        
        let recordButtonTitle = isRecording ? "Stop Recording" : "Record Audio"
        audioRecordButton.setTitle(recordButtonTitle, for: .normal)
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        originalImage = info[.originalImage] as? UIImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func recordVideo(_ sender: Any) {
        
        // Get authorization to use a video device
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            self.showCamera()
            break
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { (granted) in
                if !granted { fatalError("Experience needs camera access")}  // should do more with with errors in access request
                self.showCamera()
            }
            break
        case .denied:
            fallthrough
        case .restricted:
            fatalError("Experience needs camera access")
        }
    }
    
    private func showCamera() {
        performSegue(withIdentifier: "ShowCamera", sender: nil)
    }
    
    
    // MARK: - Private
    
    private func updateImage() {
        guard let originalImage = originalImage else { return }
        imageView.image = image(byFiltering: originalImage)
        addPosterButton.isHidden = true
    }
    
    private func image(byFiltering image: UIImage) -> UIImage? {
        
        guard let cgImage = image.cgImage else { return image }
        
        let ciImage = CIImage(cgImage: cgImage)
        monoFilter.setValue(ciImage, forKey: kCIInputImageKey)

        
        guard let outputCIImage = monoFilter.outputImage,
            let outputCGImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) else { return nil }
        
        return UIImage(cgImage: outputCGImage, scale: image.scale, orientation: image.imageOrientation)
    }
    
    private func newRecordingURL() -> URL {
        do {
            let documentsDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            
            return documentsDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("caf")
        }
        
    }
}
