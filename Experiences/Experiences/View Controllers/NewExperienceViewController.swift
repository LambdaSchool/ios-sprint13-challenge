//
//  NewExperienceViewController.swift
//  Experiences
//
//  Created by Jason Modisett on 1/18/19.
//  Copyright © 2019 Jason Modisett. All rights reserved.
//

import UIKit
import MapKit
import AVFoundation

class NewExperienceViewController: UIViewController {
    
    // MARK:- Types, properties, & IBOutlets
    
    var experienceController: ExperienceController?
    var experience: Experience?
    // MapKit
    var coordinate: CLLocationCoordinate2D?
    var mapView: MKMapView?
    // Recording
    var audioURL: URL?
    private var recorder: AVAudioRecorder?
    private var isRecording: Bool { return recorder?.isRecording ?? false }
    // Cover photo & filter
    private let filter = CIFilter(name: "CIPhotoEffectTransfer")!
    private let context = CIContext(options: nil)
    var image: UIImage?
    var originalImage: UIImage? { didSet { filterImage() }}
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var audioRecord: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    
    // MARK:- View lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    // MARK:- Record audio
    
    @IBAction func recordAudio(_ sender: Any) {
        
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
            NSLog("Error starting the recording: \(error)")
        }
    }
    
    private func updateButtons() {
        let recordButtonTitle = isRecording ? "STOP RECORDING 🔉" : "RECORD AUDIO 🔉"
        audioRecord.setTitle(recordButtonTitle, for: .normal)
    }
    
    private func newRecordingURL() -> URL {
        let documentsDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        return documentsDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("caf")
    }
    
    
    // MARK:- Add filtered image
    
    @IBAction func addImage(_ sender: Any) {
        presentImagePickerController()
    }
    
    private func presentImagePickerController() {
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
        
        guard let image = originalImage,
              let cgImage = image.cgImage else { return }
        
        let ciImage = CIImage(cgImage: cgImage)
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        
        guard let outputCIImage = filter.outputImage else { return }
        guard let outputCGImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) else { return }
        
        let filteredImage = UIImage(cgImage: outputCGImage)
        
        self.image = filteredImage
        imageView.image = filteredImage
    }
    
    @IBAction func goToVideoRecording(_ sender: Any) {
        
        guard let title = titleTextField.text,
            let coordinate = coordinate else { return }
        
        let experience = experienceController?.startExperience(title: title, coordinate: coordinate, image: image, audioURL: audioURL)
        self.experience = experience
        
        DispatchQueue.main.async {
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                self.performSegue(withIdentifier: "AddAVideo", sender: self)
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { (granted) in
                    if granted { self.performSegue(withIdentifier: "AddAVideo", sender: self) }
                    NSLog("Experiences needs video capture access.")
                }
            case .denied, .restricted:
                NSLog("Experiences needs video capture access.")
            }
        }
    }
    
    
    // MARK:- Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? RecordingViewController else { return }
        
        vc.experienceController = experienceController
        vc.experience = experience
        vc.mapView = mapView
    }
    
}

extension NewExperienceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        let image = info[.originalImage] as? UIImage
        
        originalImage = image
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension NewExperienceViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        self.audioURL = recorder.url
        self.recorder = nil
        updateButtons()
    }
}
