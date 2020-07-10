//
//  AddExperienceViewController.swift
//  Experiences
//
//  Created by Enayatullah Naseri on 3/21/20.
//  Copyright © 2020 Enayatullah Naseri. All rights reserved.
//

import UIKit
import Photos

class AddExperienceViewController: UIViewController {
    
    // MARK: - Properties
    private let context = CIContext(options: nil)
    var experienceController: ExperienceController?
    var image: UIImage?
    
    // Playback
    var audioPlayer: AVAudioPlayer?
    var timer: Timer?
    var isPlaying: Bool {
        return audioPlayer?.isPlaying ?? false
    }
    
    // Recording
    var audioRecorder: AVAudioRecorder?
    var recordedURL: URL?
    var isRecording: Bool {
        return audioRecorder?.isRecording ?? false
    }
    
    // Time formatt
    private lazy var timeFormatter: DateComponentsFormatter = {
        let formatting = DateComponentsFormatter()
        formatting.unitsStyle = .positional
        formatting.zeroFormattingBehavior = .pad
        formatting.allowedUnits = [.minute, .second]
        return formatting
    }()
    

    
    // MARK: - Outlests image
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    
    // Outlets Audio
    @IBOutlet weak var audioSlider: UISlider!
    @IBOutlet weak var playRecordingButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var timeElapLabel: UILabel!
    @IBOutlet weak var timeRemainingLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timeElapLabel.font = UIFont.monospacedDigitSystemFont(ofSize: timeElapLabel.font.pointSize, weight: .regular)
        timeRemainingLabel.font = UIFont.monospacedDigitSystemFont(ofSize: timeRemainingLabel.font.pointSize, weight: .regular)

        audioPlayer?.delegate = self
        titleTextField.delegate = self

        updateViews()
    }
    
    // MARK: - update views
    private func updateViews() {
        
        if let image = image {
            imageView.image = image
        }
        
        // audio
        playRecordingButton.isSelected = isPlaying
        
        // elapse time
        let elapseTime = audioPlayer?.currentTime ?? 0
        timeElapLabel.text = timeFormatter.string(from: elapseTime)
        
        // slider
        audioSlider.minimumValue = 0
        audioSlider.maximumValue = Float(audioPlayer?.duration ?? 0)
        audioSlider.value = Float(elapseTime)
        
        // time
        if let totalTime = audioPlayer?.duration {
            let remainingTime = totalTime - elapseTime
            timeRemainingLabel.text = timeFormatter.string(from: remainingTime)
        } else if let recordingTime = audioRecorder?.currentTime {
            timeRemainingLabel.text = timeFormatter.string(from: recordingTime)
        } else {
            timeRemainingLabel.text = timeFormatter.string(from: 0)
        }
        
        recordButton.isSelected = isRecording
        
        // Check if play button is recording
        if !isPlaying && !isRecording {
            playRecordingButton.isEnabled = true
            recordButton.isEnabled = true
        } else if isPlaying && !isRecording {
            playRecordingButton.isEnabled = true
            recordButton.isEnabled = false
        } else if !isPlaying && isRecording {
            playRecordingButton.isEnabled = false
            recordButton.isEnabled = true
        }
    }
    
    // MARK: - Filter
    private func filterImage(_ image: UIImage) -> UIImage {
        guard let cgImage = image.cgImage else { return image}
        
        let ciImage = CIImage(cgImage: cgImage)
        let filter = CIFilter(name: "CIPhotoEffectInstant")!
        filter.setValue(ciImage, forKey: "inputImage")
        
        guard let outputCIImage = filter.outputImage else { return image }
        
        let bounds = CGRect(origin: CGPoint.zero, size: image.size)
        guard let outputCGImage = context.createCGImage(outputCIImage, from: bounds) else { return image }
        
        return UIImage(cgImage: outputCGImage)
    }
    
    // MARK: - Playback
    
    private func playPause() {
        if isPlaying {
            audioPlayer?.pause()
            cancelTimer()
            updateViews()
        } else {
            audioPlayer?.play()
            startTimer()
            updateViews()
        }
    }
    
    private func startTimer() {
        cancelTimer()
        timer = Timer.scheduledTimer(timeInterval: 0.03, target: self, selector: #selector(updateTimer(timer:)), userInfo: nil, repeats: true)
    }
    
    private func cancelTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func updateTimer(timer: Timer) {
        updateViews()
    }
    
    // Record
    private func record() {
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        // time format
        let name = ISO8601DateFormatter.string(from: Date(), timeZone: .current, formatOptions: [.withInternetDateTime])
        
        //file
        let file = documentsDirectory.appendingPathComponent(name).appendingPathExtension("caf")
        
        let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1)!
        
        // Start a recoding
        audioRecorder = try! AVAudioRecorder(url: file, format: format)
        audioRecorder?.delegate = self
        audioRecorder?.record()
        cancelTimer()
        startTimer()
    }
    
    private func stopRecodring() {
        audioRecorder?.stop()
        audioRecorder = nil
        cancelTimer()
    }
    
    private func toggleRecord() {
        if isRecording {
            stopRecodring()
        } else {
            record()
        }
    }
    
    // MARK: - image picker
    private func presentImagePickerController() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            DispatchQueue.main.async {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = true
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            }
        } else if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            DispatchQueue.main.async {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        } else {
            self.presentInformationalAlertController(title: "Error", message: "The photo library or the camera is unavailable.")
        }
    }
    
    // MARK: - Action Outlets
    @IBAction func addImageButtonTapped(_ sender: Any) {
        
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch authorizationStatus {
        case .authorized:
            presentImagePickerController()
        case .notDetermined:
            
            PHPhotoLibrary.requestAuthorization { (status) in
                
                guard status == .authorized else {
                    NSLog("User did not authorize access to the photo library")
                    
                    self.presentInformationalAlertController(title: "Error", message: "In order to access the photo library, you must allow this application access photo library at settings>privacy.")
                    return
                }
                
                self.presentImagePickerController()
            }
            
        case .denied:
            self.presentInformationalAlertController(title: "Error", message: "In order to access the photo library, you must allow this application access photo library at settings>privacy.")
        case .restricted:
            self.presentInformationalAlertController(title: "Error", message: "Unable to access the photo library.")
            
        @unknown default:
            fatalError("Unhandled case for photo library authorization status")
        }
        presentImagePickerController()
        
    }
    
    @IBAction func playButtonTapped(_ sender: Any) {
        playPause()
    }
    
    @IBAction func recordButtonTapped(_ sender: Any) {
        toggleRecord()
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        // title
        guard let title = titleTextField.text, !title.isEmpty else {
            self.presentInformationalAlertController(title: "Title is required", message: "Please enter a title for the experience")
            return
        }
        // image
        guard let _ = image?.pngData(), let _ = recordedURL else {
            self.presentInformationalAlertController(title: "Image and voice record required", message: "Please select an image and record you voice")
            return
        }
        
        // Video segue
        performSegue(withIdentifier: "VideoRecordSegue", sender: self)
        
    }
    
    // MARK: - Action Button
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "VideoRecordSegue" {
        if let cameraVC = segue.destination as? CameraViewController {
                      cameraVC.experienceController = experienceController
                      cameraVC.experienceTitle = titleTextField.text
                      cameraVC.imageData = image?.pngData()
                      cameraVC.audioURL = recordedURL
                  }
       }
    }

}


// MARK: - Extentions

extension AddExperienceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        addImageButton.setTitle("", for: [])
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        self.image = filterImage(image)
        
        updateViews()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension AddExperienceViewController: AVAudioPlayerDelegate {
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let error = error {
            print("Audio playback error: \(error)")
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        updateViews()
    }
}

extension AddExperienceViewController: AVAudioRecorderDelegate {
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let error = error {
            print("Audio record error: \(error)")
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag == true {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: recorder.url)
                recordedURL = recorder.url
            } catch {
                print("Error while finishing recording: \(error)")
            }
        }
        updateViews()
    }
}

extension AddExperienceViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}
