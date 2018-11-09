//
//  AddNewExperienceViewController.swift
//  Experiences
//
//  Created by Daniela Parra on 11/9/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import UIKit
import MapKit
import AVFoundation

class AddNewExperienceViewController: UIViewController {
    
    @IBAction func continueToVideoRecording(_ sender: Any) {
        
        guard let title = titleTextField.text,
            let image = image,
            let audioURL = audioURL,
            let coordinate = coordinate else { return }
        
        let unfinishedExperience = experienceController?.startExperience(title: title, coordinate: coordinate, image: image, audioURL: audioURL)
        
        self.unfinishedExperience = unfinishedExperience
        
        performSegue(withIdentifier: "AddVideoRecording", sender: self)
    }
    
    // MARK: - Add Audio Recording
    
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
            NSLog("Error starting recording: \(error)")
        }
    }
    
    func updateButtons() {
        let recordButtonTitle = isRecording ? "Stop" : "Record Audio"
        audioRecord.setTitle(recordButtonTitle, for: .normal)
    }
    
    private func newRecordingURL() -> URL {
        let documentsDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        return documentsDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("caf")
    }
    
    // MARK: - Add Filtered Image
    
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
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        guard let destinationVC = segue.destination as? VideoRecordingViewController else { return }
        
        destinationVC.experienceController = experienceController
        destinationVC.unfinishedExperience = unfinishedExperience

    }
    
    // MARK: - Properties
    
    var experienceController: ExperienceController?
    var unfinishedExperience: Experience?
    var coordinate: CLLocationCoordinate2D?
    var audioURL: URL?
    var image: UIImage?
    var originalImage: UIImage? {
        didSet {
            filterImage()
        }
    }
    
    private let filter = CIFilter(name: "CIPhotoEffectChrome")!
    private let context = CIContext(options: nil)
    
    private var isRecording: Bool {
        return recorder?.isRecording ?? false
    }
    private var recorder: AVAudioRecorder?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var audioRecord: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
}

extension AddNewExperienceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        let image = info[.originalImage] as? UIImage
        
        originalImage = image
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension AddNewExperienceViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        self.audioURL = recorder.url
        self.recorder = nil
        updateButtons()
    }
}
