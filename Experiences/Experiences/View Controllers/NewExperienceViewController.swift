//
//  NewExperienceViewController.swift
//  Experiences
//
//  Created by Morgan Smith on 9/14/20.
//  Copyright © 2020 Morgan Smith. All rights reserved.
//

import UIKit
import CoreImage
import Photos
import AVFoundation

class NewExperienceViewController: ShiftableViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var chooseImageButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var saveButton: UIBarButtonItem!

    @IBOutlet weak var blackWhiteFilter: UIButton!

    @IBOutlet weak var invertFilter: UIButton!
    @IBOutlet weak var blurFilter: UIButton!

    @IBOutlet weak var filterImageLabel: UILabel!

    @IBOutlet weak var playRecordingButton: UIButton!


    private let context = CIContext(options: nil)

    var audioPlayer: AVAudioPlayer? {
        didSet {
            guard let audioPlayer = audioPlayer else {
                return
            }
            audioPlayer.delegate = self
            updateViews()
        }
    }

    var recordingURL: URL?
    var savedRecording: URL?
    var audioRecorder: AVAudioRecorder?

    var originalImage: UIImage? {
        didSet {

            guard let image = originalImage else { return }

            var scaledSize = imageView.bounds.size

            let scale = UIScreen.main.scale

            scaledSize = CGSize(width: scaledSize.width * scale, height: scaledSize.height * scale)

            let scaledImage = image.imageByScaling(toSize: scaledSize)

            self.scaledImage = scaledImage
        }
    }
    var scaledImage: UIImage? {
        didSet {
            imageView.image = scaledImage
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        blackWhiteFilter.alpha = 0
        invertFilter.alpha = 0
        blurFilter.alpha = 0
        filterImageLabel.alpha = 0
        playRecordingButton.alpha = 0
        originalImage = imageView.image
    }

    func updateViews() {
        playRecordingButton.isEnabled = !isRecording
        recordButton.isEnabled = !isPlaying
        playRecordingButton.isSelected = isPlaying
        recordButton.isSelected = isRecording
    }

    var isPlaying: Bool {
        audioPlayer?.isPlaying ?? false
    }


    func prepareAudioSession() throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playAndRecord, options: [.defaultToSpeaker])
        try session.setActive(true, options: []) // can fail if on a phone call, for instance
    }


    func play() {
        do {
            try prepareAudioSession()
            audioPlayer?.play()
            updateViews()
        } catch {
            print("Cannot play audio: \(error)")
        }


    }

    func pause() {
        audioPlayer?.pause()
        updateViews()
    }


    // MARK: - Recording

    var isRecording: Bool {
        audioRecorder?.isRecording ?? false
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
        do {
            try prepareAudioSession()
        } catch {
            print("Cannot record audio: \(error)")
            return
        }

        recordingURL = createNewRecordingURL()

        //can return option because you can give it invalid format and combinations
        let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1)!

        do {
            audioRecorder = try AVAudioRecorder(url: recordingURL!, format: format)
            audioRecorder?.delegate = self
            audioRecorder?.record()
            updateViews()
        } catch {
            preconditionFailure("The audio recorder could not be created with \(recordingURL!) and \(format)")
        }

    }

    func stopRecording() {
        audioRecorder?.stop()
        playRecordingButton.alpha = 1
        updateViews()
    }

    @IBAction func toggleRecording(_ sender: Any) {
        if isRecording {
            stopRecording()
        } else {
            requestPermissionOrStartRecording()
        }
    }

    @IBAction func togglePlayback(_ sender: Any) {
        if isPlaying {
            pause()
        } else {
            play()
        }

    }

    private func presentImagePickerController() {

        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            presentInformationalAlertController(title: "Error", message: "The photo library is unavailable")
            return
        }
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self

        present(imagePicker, animated: true, completion: nil)
    }
    

    @IBAction func chooseImage(_ sender: Any) {

        let authorizationStatus = PHPhotoLibrary.authorizationStatus()

        switch authorizationStatus {
        case .authorized:
            presentImagePickerController()
        case .notDetermined:

            PHPhotoLibrary.requestAuthorization { (status) in

                guard status == .authorized else {
                    NSLog("User did not authorize access to the photo library")
                    self.presentInformationalAlertController(title: "Error", message: "In order to access the photo library, you must allow this application access to it.")
                    return
                }

                self.presentImagePickerController()
            }

        case .denied:
            self.presentInformationalAlertController(title: "Error", message: "In order to access the photo library, you must allow this application access to it.")
        case .restricted:
            self.presentInformationalAlertController(title: "Error", message: "Unable to access the photo library. Your device's restrictions do not allow access.")

        @unknown default:
            print("FatalError")
        }
        presentImagePickerController()
    }


    @IBAction func blackWhiteButton(_ sender: Any) {
        if let scaledImage = scaledImage {
            if imageView.image != scaledImage {
                imageView.image = scaledImage
            } else {
                imageView.image = blackAndWhiteImage(byFiltering: scaledImage)
            }
        } else {
            imageView.image = nil
        }
    }

    @IBAction func invertButton(_ sender: Any) {
        
        if let scaledImage = scaledImage {
            if imageView.image != scaledImage {
                imageView.image = scaledImage
            } else {
                imageView.image = invertImage(byFiltering: scaledImage)
            }
        } else {
            imageView.image = nil
        }
    }


    @IBAction func blurButton(_ sender: Any) {

        if let scaledImage = scaledImage {
            if imageView.image != scaledImage {
                imageView.image = scaledImage
            } else {
                imageView.image = blurImage(byFiltering: scaledImage)
            }
        } else {
            imageView.image = nil
        }

    }

    private func blurImage(byFiltering image: UIImage) -> UIImage {

        guard let cgImage = image.cgImage else { return image}

        let ciImage = CIImage(cgImage: cgImage)

        let filter = CIFilter(name: "CIGaussianBlur")!
        filter.setValue(ciImage, forKey: "inputImage")
        filter.setValue(20, forKey: "inputRadius")


        guard let outputImage =  filter.outputImage else { return image }

        guard let outputCGImage = context.createCGImage(outputImage, from: outputImage.extent) else { return image }

        return UIImage(cgImage: outputCGImage)

    }

    private func invertImage(byFiltering image: UIImage) -> UIImage {

        guard let cgImage = image.cgImage else { return image}

        let ciImage = CIImage(cgImage: cgImage)

        let filter = CIFilter(name: "CIColorInvert")!
        filter.setValue(ciImage, forKey: "inputImage")

        guard let outputImage =  filter.outputImage else { return image }

        guard let outputCGImage = context.createCGImage(outputImage, from: outputImage.extent) else { return image }

        return UIImage(cgImage: outputCGImage)

    }

    private func blackAndWhiteImage(byFiltering image: UIImage) -> UIImage {

        guard let cgImage = image.cgImage else { return image}

        let ciImage = CIImage(cgImage: cgImage)

        let filter = CIFilter(name: "CIPhotoEffectMono")!
        filter.setValue(ciImage, forKey: "inputImage")

        guard let outputImage =  filter.outputImage else { return image }

        guard let outputCGImage = context.createCGImage(outputImage, from: outputImage.extent) else { return image }

        return UIImage(cgImage: outputCGImage)

    }

    @IBAction func SaveButton(_ sender: Any) {
        guard let title = titleTextField.text, title != "" else {
            presentInformationalAlertController(title: "Title Missing", message: "Make sure that you add a title for your experience before saving.")
            return
        }


        guard let recording = savedRecording else {
            presentInformationalAlertController(title: "Recording Missing", message: "Can't find your recording.")
            return
        }


        guard let image = UIImage(systemName: "photo") else {
            return
        }

        performSegue(withIdentifier: "saveExperience", sender: self)
    }



    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "saveExperience" {
            guard let mapVC = segue.destination as? MapViewController else { return }
            mapVC.image = imageView.image
            mapVC.audio = savedRecording
            mapVC.experienceTitle = titleTextField.text
        }
    }


}

extension NewExperienceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        chooseImageButton.setTitle("", for: [])
        blackWhiteFilter.alpha = 1
        invertFilter.alpha = 1
        blurFilter.alpha = 1
        filterImageLabel.alpha = 1

        if let selectedImage = info[.originalImage] as? UIImage {
            originalImage = selectedImage
        }

        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension NewExperienceViewController: AVAudioPlayerDelegate {

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        updateViews()
    }

    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let error = error {
            print("Audio Player Error: \(error)")
        }
    }
}

extension NewExperienceViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if let recordingURL = recordingURL {
            audioPlayer = try? AVAudioPlayer(contentsOf: recordingURL)
            savedRecording = recordingURL
        }
        recordingURL = nil

    }
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let error = error {
            print("Audio Recorder Error: \(error)")
        }
    }
}



