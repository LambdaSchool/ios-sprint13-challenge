//
//  AudioViewController.swift
//  Experiences
//
//  Created by denis cedeno on 5/19/20.
//  Copyright © 2020 DenCedeno Co. All rights reserved.
//


import UIKit
import AVFoundation

class AudioViewController: UIViewController {
    
    var experience: Experience?
    var UUIDString: String = ""
    
    var audioPlayer: AVAudioPlayer? {
        didSet {
            guard let audioPlayer = audioPlayer else { return }
            audioPlayer.delegate = self
            audioPlayer.isMeteringEnabled = true
        }
    }
    
    var recordingURL: URL?
    var audioRecorder: AVAudioRecorder?
    
    @IBOutlet var playButton: UIButton!
    @IBOutlet var recordButton: UIButton!
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAudio()
        updateViews()
        UUIDString = "\(experience?.uuid?.uuidString ?? "")"
    }
    
    func updateViews() {
        playButton.isSelected = isPlaying
    }
    
    // MARK: - Playback
    var isPlaying: Bool {
        audioPlayer?.isPlaying ?? false
    }
    
    func loadAudio() {
        let songURL = Bundle.main.url(forResource: "piano", withExtension: "mp3")!
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: songURL)
        } catch {
            preconditionFailure("Failure to load audio file: \(error)")
        }
    }
    
    // remember this code if mute is turned on
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
            print("cannot play audio: \(error)")
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
        
        let name = UUIDString
        print(name)
        let file = documents.appendingPathComponent(name, isDirectory: false).appendingPathExtension("caf")
        
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
        
        let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1)!
        do {
            print("\(String(describing: recordingURL))")
            audioRecorder = try AVAudioRecorder(url: recordingURL!, format: format)
            audioRecorder?.delegate = self
            audioRecorder?.record()
        } catch {
            preconditionFailure("The audio recorder could not be created with \(recordingURL!) and \(format)")
        }
    }
    
    func stopRecording() {
        audioRecorder?.stop()
    }
    
    // MARK: - Actions
    
    @IBAction func togglePlayback(_ sender: Any) {
        if isPlaying{
            pause()
        } else {
            play()
        }
    }
    
    
    @IBAction func toggleRecording(_ sender: Any) {
        if isRecording {
            stopRecording()
            recordButton.backgroundColor = .none
        } else {
            requestPermissionOrStartRecording()
            
            recordButton.backgroundColor = .red
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "VideoNextSegue" {
            guard let videoVC = segue.destination as? AudioViewController else { return }
            videoVC.experience = self.experience
        } else if segue.identifier == "VideoSegue" {
            guard let videoVC = segue.destination as? AudioViewController else { return }
            videoVC.experience = self.experience
        }
    }
}

extension AudioViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        updateViews()
    }
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let error = error {
            print("Audio Player error: \(error)")
        }
    }
}

extension AudioViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if let recordingURL = recordingURL {
            audioPlayer = try? AVAudioPlayer(contentsOf: recordingURL)
        }
        audioRecorder = nil
    }
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let error = error {
            print("Audio Recorder error: \(error)")
        }
    }
}

