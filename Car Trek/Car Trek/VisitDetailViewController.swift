//
//  VisitDetailViewController.swift
//  Road Trip
//
//  Created by Christy Hicks on 5/17/20.
//  Copyright © 2020 Knight Night. All rights reserved.
//

import UIKit
import AVFoundation
import MapKit

class VisitDetailViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet var nameTextField: UITextField! {
        didSet {
            nameTextField.delegate = self
        }
    }
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var audioElapsedTimeLabel: UILabel!
    @IBOutlet var audioTimeRemainingLabel: UILabel!
    @IBOutlet var audioSlider: UISlider!
    @IBOutlet var audioPlayButton: UIButton!
    @IBOutlet var recordAudioButton: UIButton!
    @IBOutlet var viewVideoButton: UIButton!
    @IBOutlet var recordVideoButton: UIButton!
    
    // MARK: - Properties
    // General
    var visit: Visit?
    var indexPath: IndexPath?
    var visitDelegate: VisitDelegate?
    var recordingExists = false
    
    // Map
    var newLocation: CLLocationCoordinate2D?
    
    // Image
    var newImage: UIImage?
    
    // Timer
    weak var timer: Timer?
    private lazy var timeIntervalFormatter: DateComponentsFormatter = {
        let formatting = DateComponentsFormatter()
        formatting.unitsStyle = .positional
        formatting.zeroFormattingBehavior = .pad
        formatting.allowedUnits = [.minute, .second]
        return formatting
    }()
    
    deinit {
        timer?.invalidate()
    }
    
    // Audio
    
    var audioRecordingURL: URL?
    var audioRecorder: AVAudioRecorder?
    
    var audioIsRecording: Bool {
        audioRecorder?.isRecording ?? false
    }
    
    var audioPlayer: AVAudioPlayer? {
        didSet {
            guard let audioPlayer = audioPlayer else { return }
            audioPlayer.delegate = self
            updateViews()
        }
    }
    
    var audioIsPlaying: Bool {
        audioPlayer?.isPlaying ?? false
    }
    
    // Video
    var videoRecordingURL: URL?
    
   
    // MARK: - Views
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
        loadAudio()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        updateViews()
    }
    
    func updateViews() {
        audioElapsedTimeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: audioElapsedTimeLabel.font.pointSize, weight: .regular)
        audioTimeRemainingLabel.font = UIFont.monospacedDigitSystemFont(ofSize: audioTimeRemainingLabel.font.pointSize, weight: .regular)
        
        audioPlayButton.isSelected = audioIsPlaying
        recordAudioButton.isSelected = audioIsRecording
        newImage = photoImageView.image
        
        if audioIsPlaying {
            updateAudioSlider()
            audioPlayButton.title(for: .selected)
        } else {
            audioPlayButton.title(for: .normal)
        }
        
        viewVideoButton.isHidden = true
        
        guard let visit = visit else { return }
        let name = visit.name
        nameTextField.text = name
        
        if let photo = visit.photo {
            photoImageView.image = photo
        }
        
        if recordingExists {
            viewVideoButton.isHidden = false
        }
    }
    
    func updateAudioSlider() {
        let elapsedTime = audioPlayer?.currentTime ?? 0
        let duration = audioPlayer?.duration ?? 20
        let timeRemaining = duration.rounded() - elapsedTime
        
        audioElapsedTimeLabel.text = timeIntervalFormatter.string(from: elapsedTime)
        audioTimeRemainingLabel.text = timeIntervalFormatter.string(from: timeRemaining)
        
        audioSlider.minimumValue = 0
        audioSlider.maximumValue = Float(duration)
        audioSlider.value = Float(elapsedTime)
    }
    
    // MARK: - Actions
    @IBAction func addPhoto(_ sender: UIButton) {
        presentImagePickerController()
    }
    
    @IBAction func addAudioRecording(_ sender: UIButton) {
        if audioIsRecording == false {
            audioPlayButton.isSelected = false
            audioPlayer?.pause()
            requestPermissionOrStartRecording()
        } else {
            stopRecording()
        }
        updateViews()
    }
    
    @IBAction func audioPlayButton(_ sender: UIButton) {
        if audioIsRecording {
            stopRecording()
        }
        if audioIsPlaying {
            pauseAudio()
        } else {
            playAudio()
        }
    }
    
    @IBAction func saveVisit(_ sender: UIBarButtonItem) {
        if visit == nil {
            guard let name = nameTextField.text, let location = newLocation else {
                print("Need to add a name or location.")
                return
            }

            let audioURL = audioRecordingURL
            let videoURL = videoRecordingURL
            let newVisit: Visit = Visit(name: name, location: location, photo: photoImageView.image, audioURL: audioURL, videoURL: videoURL)
            visitDelegate?.saveNew(visit: newVisit)
            navigationController?.popViewController(animated: true)
            
        } else {
            guard let name = nameTextField.text, let location = newLocation, let visit = visit, let indexPath = indexPath else {
                print("Need to add a name.")
                return
            }
            
            let audioURL = audioRecordingURL
            let videoURL = videoRecordingURL
            let image = photoImageView.image
            
            visit.name = name
            visit.audioRecordingURL = audioURL
            visit.videoRecordingURL = videoURL
            visit.photo = image
            visit.location = location
            
            visitDelegate?.update(visit: visit, indexPath: indexPath)
            navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - Methods
    // Image
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
    
    func loadPhoto() {
        photoImageView.image = newImage
    }
    
    // Timer
    func startTimer() {
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.030, repeats: true) { [weak self] (_) in
            guard let self = self else { return }
            
            self.updateViews()
        }
    }
    
    func cancelTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    // Record Audio
    func createNewAudioRecordingURL() -> URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let name = ISO8601DateFormatter.string(from: Date(), timeZone: .current, formatOptions: .withInternetDateTime)
        let file = documents.appendingPathComponent(name, isDirectory: false).appendingPathExtension("caf")
        
        print("Audio recording URL: \(file)")
        
        return file
    }
    
    func requestPermissionOrStartRecording() {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission { (granted) in
                guard granted == true else {
                    print("We need microphone access.")
                    return
                }
                print("Microphone access has been granted!")
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
        
        audioRecordingURL = createNewAudioRecordingURL()
        
        let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1)!
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioRecordingURL!, format: format)
            audioRecorder?.delegate = self
            audioRecorder?.record()
        } catch {
            preconditionFailure("The audio recorder could not be created with \(audioRecordingURL!) and \(format)")
        }
        
        visit?.audioRecordingURL = audioRecordingURL
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        visit?.audioRecordingURL = audioRecordingURL
    }
    
    // Play audio
    func prepareAudioSession() throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playAndRecord, options: [.defaultToSpeaker])
        try session.setActive(true, options: [])
    }
    
    func loadAudio() {
        guard let visit = visit, let audioURL = visit.audioRecordingURL else { return }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
        } catch {
            preconditionFailure("Failure to load audio file: \(error)")
        }
    }
    
    func playAudio() {
        do {
            try prepareAudioSession()
            audioPlayer?.play()
            updateViews()
            startTimer()
        } catch {
            print("Cannot play audio: \(error)")
        }
    }
    
    func pauseAudio() {
        audioPlayer?.pause()
        updateViews()
        cancelTimer()
    }

    // MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "addVideoSegue" {
        let cameraVC = segue.destination as! CameraViewController
        cameraVC.visit = self.visit
        cameraVC.cameraDelegate = self
        cameraVC.recordingExists = false
        
    } else if segue.identifier == "viewVideoSegue" {
        let cameraVC = segue.destination as! CameraViewController
        cameraVC.visit = self.visit
        cameraVC.cameraDelegate = self
        cameraVC.recordingExists = true
        cameraVC.videoURL = visit?.videoRecordingURL
        }
    }
}


// MARK: - Delegates
// General
protocol VisitDelegate {
    func saveNew(visit: Visit)
    func update(visit: Visit, indexPath: IndexPath)
}

// Image Delegate
extension VisitDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            newImage = image
        } else if let image = info[.originalImage] as? UIImage {
            newImage = image
        }
        
        picker.dismiss(animated: true, completion: nil)
        loadPhoto()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

// Audio Delegate
extension VisitDetailViewController: AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if let recordingURL = audioRecordingURL {
            audioPlayer = try? AVAudioPlayer(contentsOf: recordingURL)
            audioRecorder = nil
        }
        
        func audioPlayerDecodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
            if let error = error {
                print("Audio Recorder Error: \(error)")
            }
        }
    }
}

extension VisitDetailViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// Video Delegate
extension VisitDetailViewController: CameraDelegate {
    func saveURL(url: URL) {
        videoRecordingURL = url
    }
}

