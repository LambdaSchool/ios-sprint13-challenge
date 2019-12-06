//
//  AddExperienceViewController.swift
//  Experiences-sprint-chanllenge
//
//  Created by Gi Pyo Kim on 12/6/19.
//  Copyright © 2019 GIPGIP Studio. All rights reserved.
//

import UIKit
import Photos

class AddExperienceViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    
    // Audio
    @IBOutlet weak var audioSlider: UISlider!
    @IBOutlet weak var timeElapsedLabel: UILabel!
    @IBOutlet weak var timeRemainingLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    // Playback properties
    var audioPlayer: AVAudioPlayer?
    var timer: Timer?
    var isPlaying: Bool {
        return audioPlayer?.isPlaying ?? false
    }
    
    // Recording properties
    var audioRecorder: AVAudioRecorder?
    var recordedURL: URL?
    var isRecording: Bool {
        return audioRecorder?.isRecording ?? false
    }
    
    private lazy var timeFormatter: DateComponentsFormatter = {
        let formatting = DateComponentsFormatter()
        formatting.unitsStyle = .positional
        formatting.zeroFormattingBehavior = .pad
        formatting.allowedUnits = [.minute, .second]
        return formatting
    }()
    
    private let context = CIContext(options: nil)
    var experienceController: ExperienceController?
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timeElapsedLabel.font = UIFont.monospacedDigitSystemFont(ofSize: timeElapsedLabel.font.pointSize, weight: .regular)
        timeRemainingLabel.font = UIFont.monospacedDigitSystemFont(ofSize: timeRemainingLabel.font.pointSize, weight: .regular)

        audioPlayer?.delegate = self
        titleTextField.delegate = self
        
        updateViews()
    }
    
    private func updateViews() {
        // image
        if let image = image {
            imageView.image = image
        }
        
        // audio
        playButton.isSelected = isPlaying
        
        let elapsedTime = audioPlayer?.currentTime ?? 0
        timeElapsedLabel.text = timeFormatter.string(from: elapsedTime)
        
        audioSlider.minimumValue = 0
        audioSlider.maximumValue = Float(audioPlayer?.duration ?? 0)
        audioSlider.value = Float(elapsedTime)
        
        if let totalTime = audioPlayer?.duration {
            let remainingTime = totalTime - elapsedTime
            timeRemainingLabel.text = timeFormatter.string(from: remainingTime)
        } else if let recordingTime = audioRecorder?.currentTime {
            timeRemainingLabel.text = timeFormatter.string(from: recordingTime)
        } else {
            timeRemainingLabel.text = timeFormatter.string(from: 0)
        }
        
        recordButton.isSelected = isRecording
        
        if !isPlaying && !isRecording {
            playButton.isEnabled = true
            recordButton.isEnabled = true
        } else if isPlaying && !isRecording {
            playButton.isEnabled = true
            recordButton.isEnabled = false
        } else if !isPlaying && isRecording {
            playButton.isEnabled = false
            recordButton.isEnabled = true
        }
    }
    
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
    
    // Playback
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
        // Path to save in the documents direcgtory
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        // Filename (ISO8601 format for time) .caf extension (core audio file)
        let name = ISO8601DateFormatter.string(from: Date(), timeZone: .current, formatOptions: [.withInternetDateTime])
        
        // 2019-12-03T10:42:35-08:00.caf
        let file = documentsDirectory.appendingPathComponent(name).appendingPathExtension("caf")
        
        print("Record URL: \(file)")
        // Audio Quality 44.1KHz
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
    
    @IBAction func addImage(_ sender: Any) {
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
            fatalError("Unhandled case for photo library authorization status")
        }
        presentImagePickerController()
    }
    
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
    
    @IBAction func playButtonPressed(_ sender: Any) {
        playPause()
    }
    @IBAction func recordButtonPressed(_ sender: Any) {
        toggleRecord()
    }
    
    @IBAction func showLivePreview(_ sender: Any) {
        guard let title = titleTextField.text, !title.isEmpty else {
            self.presentInformationalAlertController(title: "Title Required", message: "Please enter a title for the experience")
            return
        }
        
        guard let _ = image?.pngData(), let _ = recordedURL else {
            self.presentInformationalAlertController(title: "Image and voice record required", message: "Please select an image and record you voice")
            return
        }
        
        // perform segue
        performSegue(withIdentifier: "VideoRecordSegue", sender: self)
        
    }
    

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
