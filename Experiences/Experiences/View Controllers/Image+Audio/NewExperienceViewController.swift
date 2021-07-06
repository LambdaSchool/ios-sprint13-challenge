//
//  NewExperienceViewController.swift
//  Experiences
//
//  Created by Mitchell Budge on 7/12/19.
//  Copyright © 2019 Mitchell Budge. All rights reserved.
//

import UIKit
import Photos
import AVFoundation

class NewExperienceViewController: UIViewController {

    // MARK: - Properties
    
    var experienceController: ExperienceController?
    var coordinate: CLLocationCoordinate2D?
    var originalImage: UIImage? {
        didSet {
            updateImage()
        }
    }
    var image: UIImage?
    private let filter = CIFilter(name: "CIPhotoEffectNoir")!
    private let context = CIContext(options: nil)
    private var recorder: AVAudioRecorder?
    var isRecording: Bool {
        return recorder?.isRecording ?? false
    }
    var audio: URL?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var addPosterImageButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recorder?.delegate = self
    }
    
    func updateImage() {
        if let originalImage = originalImage {
            imageView.image = image(byFiltering: originalImage.imageByScaling(toSize: view.bounds.size)!)
        } else {
            imageView.image = nil
        }
    }
    
    private func image(byFiltering image: UIImage) -> UIImage {
        guard let cgImage = image.cgImage else { return image }
        let ciImage = CIImage(cgImage: cgImage)
        filter.setValue(ciImage, forKey: "inputImage")
        guard let outputCIImage = filter.outputImage else { return image }
        guard let outputCGImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) else { return image }
        return UIImage(cgImage: outputCGImage)
    }
    
    @IBAction func addPosterImageButtonPressed(_ sender: Any) {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            NSLog("The photo library is unavailable")
            return
        }
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func updateViews() {
        let recordButtonText = isRecording ? "Stop recording" : "Start recording"
        recordButton.setTitle(recordButtonText, for: .normal)
    }
    
    private func newRecordingURL() -> URL {
        let documentsDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let audioURL = documentsDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("caf")
        return audioURL
    }
    
    @IBAction func recordButtonPressed(_ sender: Any) {
        if isRecording {
            recorder?.stop()
            return
        }
        do {
            let format = AVAudioFormat(standardFormatWithSampleRate: 44100.0, channels: 2)!
            recorder = try AVAudioRecorder(url: newRecordingURL(), format: format)
            recorder?.record()
            recorder?.delegate = self
        } catch {
            NSLog("Unable to record: \(error)")
        }
        updateViews()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddVideoSegue" {
            guard let videoVC = segue.destination as? VideoRecordingViewController else { return }
            videoVC.experienceController = experienceController
            videoVC.coordinate = coordinate
            videoVC.name = titleTextField.text
            videoVC.image = originalImage
            videoVC.audio = audio
        }
    }
    
}

extension NewExperienceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVAudioRecorderDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            originalImage = image
            addPosterImageButton.isHidden = true
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        updateViews()
        audio = recorder.url
    }
    
}
