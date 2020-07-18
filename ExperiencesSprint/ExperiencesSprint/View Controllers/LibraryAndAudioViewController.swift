//
//  LibraryAndAudioViewController.swift
//  ExperiencesSprint
//
//  Created by Jarren Campos on 7/17/20.
//  Copyright © 2020 Jarren Campos. All rights reserved.
//

import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins
import Photos

class LibraryAndAudioViewController: UIViewController {
    
    // Image Code
    var pictureChanged: Bool = false
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var chooseImageButton: UIButton!
    @IBOutlet var changeCurrentImage: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeCurrentImage.alpha = 0
        
        //Audio Code
        timeElapsedLabel.font = UIFont.monospacedDigitSystemFont(
            ofSize: timeElapsedLabel.font.pointSize,
            weight: .regular
        )
        timeRemainingLabel.font = UIFont.monospacedDigitSystemFont(
            ofSize: timeRemainingLabel.font.pointSize,
            weight: .regular
        )
    }
    
    private func presentImagePickerController() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("The photo library is not available.")
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func presentFailureAlert() {
        let alert = UIAlertController(title: "Failure", message: "Please add an image first.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: Actions
    
    @IBAction func choosePhotoButtonPressed(_ sender: Any) {
        presentImagePickerController()
    }
    
    @IBAction func changeCurrentPicturePressed(_ sender: Any) {
        presentImagePickerController()
    }
    @IBAction func nextNavBarButtonPressed(_ sender: Any) {
        if pictureChanged == true {
            performSegue(withIdentifier: "toCreatePostVC", sender: UIButton.self)
        } else {
            presentFailureAlert()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! CreatePostViewController
        destVC.currentPicture = imageView.image
    }
    
    // Audio Code
    var audioPlayer: AVAudioPlayer? {
        didSet {
            guard let audioPlayer = audioPlayer else { return }
            
            audioPlayer.delegate = self
            audioPlayer.isMeteringEnabled = true
            updateViews()
        }
    }
    
    weak var timer: Timer?
    
    var recordingURL: URL?
    var audioRecorder: AVAudioRecorder?
    
    @IBOutlet var playButton: UIButton!
    @IBOutlet var recordButton: UIButton!
    @IBOutlet var timeElapsedLabel: UILabel!
    @IBOutlet var timeRemainingLabel: UILabel!
    @IBOutlet var timeSlider: UISlider!
    
    private lazy var timeIntervalFormatter: DateComponentsFormatter = {
        
        let formatting = DateComponentsFormatter()
        formatting.unitsStyle = .positional // 00:00  mm:ss
        formatting.zeroFormattingBehavior = .pad
        formatting.allowedUnits = [.minute, .second]
        return formatting
    }()
    
    func updateViews() {
        playButton.isEnabled = !isRecording
        recordButton.isEnabled = !isPlaying
        timeSlider.isEnabled = !isRecording
        
        playButton.isSelected = isPlaying
        recordButton.isSelected = isRecording
        
        if !isRecording {
            let elapsedTime = audioPlayer?.currentTime ?? 0
            let duration = audioPlayer?.duration ?? 0
            let timeRemaining = duration.rounded() - elapsedTime
            
            timeElapsedLabel.text = timeIntervalFormatter.string(from: elapsedTime)
            
            timeSlider.minimumValue = 0
            timeSlider.maximumValue = Float(duration)
            timeSlider.value = Float(elapsedTime)
            
            timeRemainingLabel.text = "-" + timeIntervalFormatter.string(from: timeRemaining)!
        } else {
            let elapsedTime = audioRecorder?.currentTime ?? 0
            
            timeElapsedLabel.text = "--:--"
            
            timeSlider.minimumValue = 0
            timeSlider.maximumValue = 1
            timeSlider.value = 0
            
            timeRemainingLabel.text = timeIntervalFormatter.string(from: elapsedTime)
        }
    }
    
    deinit {
        timer?.invalidate()
    }
    
    // MARK: - Timer
    
    func startTimer() {
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.030, repeats: true) { [weak self] (_) in
            guard let self = self else { return }
            
            self.updateViews()
            
            if let audioRecorder = self.audioRecorder,
                self.isRecording == true {
                
                audioRecorder.updateMeters()
                
            }
            
            if let audioPlayer = self.audioPlayer,
                self.isPlaying == true {
                
                audioPlayer.updateMeters()
                
            }
        }
    }
    
    func cancelTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    
    // MARK: - Playback
    
    var isPlaying: Bool {
        audioPlayer?.isPlaying ?? false
    }
    
    func prepareAudioSession() throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playAndRecord, options: [.defaultToSpeaker])
        try session.setActive(true, options: [])
    }
    
    func play() {
        do {
            try prepareAudioSession()
            audioPlayer?.play()
            updateViews()
            startTimer()
        } catch {
            print("Cannot play audio: \(error)")
        }
    }
    
    func pause() {
        audioPlayer?.pause()
        updateViews()
        cancelTimer()
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
        
        let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1)!
        
        do {
            audioRecorder = try AVAudioRecorder(url: recordingURL!, format: format)
            audioRecorder?.delegate = self
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.record()
            updateViews()
            startTimer()
        } catch {
            preconditionFailure("The audio recorder could not be created with \(recordingURL!) and \(format): \(error)")
        }
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        updateViews()
        cancelTimer()
    }
    
    // MARK: - Actions
    
    @IBAction func togglePlayback(_ sender: Any) {
        if isPlaying {
            pause()
        } else {
            play()
        }
    }
    
    @IBAction func updateCurrentTime(_ sender: UISlider) {
        if isPlaying {
            pause()
        }
        
        audioPlayer?.currentTime = TimeInterval(sender.value)
        updateViews()
    }
    
    @IBAction func toggleRecording(_ sender: Any) {
        if isRecording {
            stopRecording()
        } else {
            requestPermissionOrStartRecording()
        }
    }
    
    @IBAction func unwindToLibraryAndAudioVC(_ sender: UIStoryboardSegue){}
}


extension LibraryAndAudioViewController: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        updateViews()
        cancelTimer()
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let error = error {
            print("Audio Player Error: \(error)")
        }
    }
    
}

extension LibraryAndAudioViewController: AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if let recordingURL = recordingURL {
            audioPlayer = try? AVAudioPlayer(contentsOf: recordingURL)
        }
        audioRecorder = nil
        cancelTimer()
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let error = error {
            print("Audio Recorder Error: \(error)")
        }
    }
    
}

extension LibraryAndAudioViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            imageView.image = image
            self.chooseImageButton.alpha = 0
            self.changeCurrentImage.alpha = 1
            self.pictureChanged = true
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
