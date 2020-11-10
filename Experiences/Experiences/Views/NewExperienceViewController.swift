//
//  NewExperienceViewController.swift
//  Experiences
//
//  Created by Craig Belinfante on 11/8/20.
//  Copyright © 2020 Craig Belinfante. All rights reserved.
//

import UIKit
import MapKit
import AVFoundation

class NewExperienceViewController: UIViewController {
    
    var experienceController: ExperienceController?
    var currentImage: UIImage? {
        didSet {
         //   prepareForRecord()
        }
    }
    var recordingURL: URL?
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer? {
        didSet {
            guard let audioPlayer = audioPlayer else { return }
            
            audioPlayer.delegate = self
            audioPlayer.isMeteringEnabled = true
            updateViews()
        }
    }
    var isRecording: Bool {
        audioRecorder?.isRecording ?? false
    }
    var isPlaying: Bool {
        audioPlayer?.isPlaying ?? false
    }
    
    @IBOutlet weak var experienceTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordAudioButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAudio()
        recordButton.isEnabled = false
        //recordAudioButton.isEnabled = false
    }
    
    @IBAction func addPhoto(_ sender: UIButton) {
        guard let title = experienceTextField.text, !title.isEmpty else {return}
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            fatalError("Cannot add photo")
        }
        
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @IBAction func recordButtonPressed(_ sender: UIButton) {
        guard currentImage != nil else {return}
    }
    
    
    @IBAction func toggleAudioRecording(_ sender: UIButton) {
        guard let title = experienceTextField.text, !title.isEmpty else {return}
        //  guard currentImage != nil else {return}
        
        if isRecording {
            stopRecording()
        } else {
            requestPermissionOrStartRecording()
        }
    }
    
    @IBAction func playAudio(_ sender: UIButton) {
        if isPlaying {
                   pause()
               } else {
                   play()
               }
    }
    
    func updateViews() {
        playButton.isEnabled = !isRecording
        recordAudioButton.isEnabled = !isPlaying
        
        playButton.isSelected = isPlaying
        recordAudioButton.isSelected = isRecording
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
    
//    func prepareForRecord() {
//        imageView.image = currentImage!
//        recordButton.isEnabled = true
//        recordAudioButton.isEnabled = true
//    }
    
    func prepareAudioSession() throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playAndRecord, options: [.defaultToSpeaker])
        try session.setActive(true, options: [])
    }
    
    func createNewAudioRecordingURL() -> URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let name = ISO8601DateFormatter.string(from: Date(), timeZone: .current, formatOptions: .withInternetDateTime)
        let file = documents.appendingPathComponent(name, isDirectory: false).appendingPathExtension("caf")
        
        print("recording URL: \(file)")
        
        return file
    }
    
    func newVideoRecordingURL(fileTitle: String) -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let url = documentsDirectory.appendingPathComponent(fileTitle).appendingPathExtension("mp3")
        return url
    }
    
    func startRecording() {
        do {
            try prepareAudioSession()
        } catch {
            print("Cannot record audio: \(error)")
            return
        }
        
        recordingURL = createNewAudioRecordingURL()
        
        let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1)!
        
        do {
            audioRecorder = try AVAudioRecorder(url: recordingURL!, format: format)
            audioRecorder?.delegate = self
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.record()
            updateViews()
        } catch {
            preconditionFailure("The audio recorder could not be created with \(recordingURL!) and \(format)")
        }
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        updateViews()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CameraViewController" {
            guard let VC = segue.destination as? CameraViewController,
                let fileTitle = experienceTextField.text, !fileTitle.isEmpty else {return}
            
            VC.fileTitle = fileTitle
            VC.experienceController = experienceController
        }
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
    
    func loadAudio() {
           let songURL = Bundle.main.url(forResource: "piano copy", withExtension: "mp3")!
           
           do {
               audioPlayer = try AVAudioPlayer(contentsOf: songURL)
           } catch {
               preconditionFailure("Failure to load audio file: \(error)")
           }
       }
    
}

extension NewExperienceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        imageView.image = image
        dismiss(animated: true)
        currentImage = image
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
        }
        recordingURL = nil
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let error = error {
            print("Audio Recorder Error: \(error)")
        }
    }
    
}
