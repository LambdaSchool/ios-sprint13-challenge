//
//  ExperienceDetailViewController.swift
//  Experiences Sprint
//
//  Created by Harmony Radley on 7/10/20.
//  Copyright © 2020 Harmony Radley. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Photos
import AVFoundation
import CoreImage
import CoreImage.CIFilterBuiltins

class ExperienceDetailViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var addImage: UIButton!
    @IBOutlet var recordAudioButton: UIButton!


    // MARK: - Properites

    var experienceController: ExperienceController?
    var coordinate: CLLocationCoordinate2D?
    var recordingURL: URL?
    var audioRecorder: AVAudioRecorder?
    private let context = CIContext(options: nil)

    var isRecording: Bool {
        audioRecorder?.isRecording ?? false
    }

    var audioPlayer: AVAudioPlayer? {
        didSet {
            guard let audioPlayer = audioPlayer else { return }
            audioPlayer.delegate = self
            audioPlayer.isMeteringEnabled = true
        }
    }

    var image: UIImage? {
        didSet {
            imageView.image = image?.flattened
        }
    }

    // MARK: - View Controller LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }

    func updateViews() {
        DispatchQueue.main.async {
            if self.isRecording {
                self.recordAudioButton.setTitle("Stop Recording", for: .normal)
            } else {
                self.recordAudioButton.setTitle("Record", for: .normal)
            }
        }
    }

    // MARK: - Images

    func image(byFiltering image: UIImage) -> UIImage {
        guard let cgImage = image.cgImage else { return image}

        let ciImage = CIImage(cgImage: cgImage)

        let filter = CIFilter.photoEffectNoir()

        filter.inputImage = ciImage

        guard let outputImage = filter.outputImage else { return image }

        guard let outputCGImage = context.createCGImage(outputImage, from: outputImage.extent) else { return image }

        return UIImage(cgImage: outputCGImage, scale: image.scale, orientation: image.imageOrientation)
    }

    func presentImagePicker() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }

        let imagePicker = UIImagePickerController()

        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self

        present(imagePicker, animated: true, completion: nil)
    }

    // MARK: - Actions

    @IBAction func recordAudioButtonTapped(_ sender: Any) {
        if isRecording {
            stopRecording()
        } else {
            startRecording()
        }
    }
    
    @IBAction func addImageButtonTapped(_ sender: Any) {
        presentImagePicker()
    }

    @IBAction func saveButtonTapped(_ sender: Any) {

        if isRecording == true { return }

        guard let title = titleTextField.text,
            !title.isEmpty else { return }

        var newImage: UIImage? = nil
        if let image = imageView.image { newImage = image }

        var newAudio:  URL? = nil

        if let audio = recordingURL {
            newAudio = audio
        }

        guard let coordinate = coordinate else { return }
        let experience = Experience(title: title, image: newImage, audio: newAudio, coordinate: coordinate)

        experienceController?.experiences.append(experience)

        navigationController?.popToRootViewController(animated: true)
    }

    // MARK: - Audio Recording

    func startRecording() {
        // Grab the recording URL
        recordingURL = createNewRecordingURL()

        // Check for permission
        AVAudioSession.sharedInstance().requestRecordPermission { (granted) in

            guard granted else {
                NSLog("We need microphone access")
                return
            }

            // Set up the recorder (give it the settings we want, etc.)
            guard let recordingURL = self.recordingURL else {
                NSLog("No recording URL available")
                return
            }

            let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1)!
            do {
                self.audioRecorder?.delegate = self
                self.audioRecorder = try AVAudioRecorder(url: recordingURL, format: format)
                self.audioRecorder?.isMeteringEnabled = true
                // Start recording
                self.audioRecorder?.record()
                self.updateViews()
            } catch {
                NSLog("Error setting up audio recorder: \(error)")
            }
        }
    }

    func stopRecording() {
        audioRecorder?.stop()
        audioRecorder = nil
        updateViews()
    }

    func requestPermissionOrStartRecording() {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                guard granted == true else {
                    print("We need access to the microphone to record a note.")
                    return
                }
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

    func createNewRecordingURL() -> URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        let name = ISO8601DateFormatter.string(from: Date(), timeZone: .current, formatOptions: .withInternetDateTime)
        let file = documents.appendingPathComponent(name, isDirectory: false).appendingPathExtension("caf")

        print("recording URL: \(file)")

        return file
    }
}

// MARK: - Audio Extensions

extension ExperienceDetailViewController: AVAudioRecorderDelegate {

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        guard let recordingURL = recordingURL else { return }
        print("Finished recording: \(recordingURL.path)")
        audioPlayer = try? AVAudioPlayer(contentsOf: recordingURL)
        updateViews()
    }

    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let error = error {
            print("Error recording: \(error)")
        }
        updateViews()
    }
}

extension ExperienceDetailViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        DispatchQueue.main.async {
            self.updateViews()
        }
    }

    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let error = error {
            print(error)
        }
        DispatchQueue.main.async {
            self.updateViews()
        }
    }
}

// MARK: - Image Extension

extension ExperienceDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        guard let selectedImage = info[.originalImage] as? UIImage else { return }

        self.image = image(byFiltering: selectedImage)

        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
