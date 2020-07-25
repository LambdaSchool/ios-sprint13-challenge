//
//  RecordingViewController.swift
//  Experiences
//
//  Created by Kevin Stewart on 7/17/20.
//  Copyright © 2020 Kevin Stewart. All rights reserved.
//

import UIKit
import AVFoundation
import CoreLocation


class RecordingViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet var playButton: UIButton!
    @IBOutlet var timeRemainingLabel: UILabel!
    @IBOutlet var timeElapsedLabel: UILabel!
    @IBOutlet var timeSlider: UISlider!
    @IBOutlet var recordButton: UIButton!
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var saveButton: UIBarButtonItem!
    
    //MARK: - Properties
    var audioPlayer: AVAudioPlayer? {
        didSet {
            guard let audioPlayer = audioPlayer else { return }
            audioPlayer.delegate = self
            audioPlayer.isMeteringEnabled = true
            updateViews()
        }
    }
    var location: LocationService?
    var mapViewController: MapViewController?
    var delegate: AddExperienceDelegate!
    var experienceController: ExperienceController?
    var experience: Experience? {
        didSet {
            updateViews()
        }
    }
    weak var timer: Timer?
    var recordingURL: URL?
    var audioRecorder: AVAudioRecorder?
    
    // Formatter for time time remaining and time elapsed
    private lazy var timeIntervalFormatter: DateComponentsFormatter = {
        // NOTE: DateComponentFormatter is good for minutes/hours/seconds
        // DateComponentsFormatter is not good for milliseconds, use DateFormatter instead)
        
        let formatting = DateComponentsFormatter()
        formatting.unitsStyle = .positional // 00:00  mm:ss
        formatting.zeroFormattingBehavior = .pad
        formatting.allowedUnits = [.minute, .second]
        return formatting
    }()
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        timeElapsedLabel.font = UIFont.monospacedDigitSystemFont(ofSize: timeElapsedLabel.font.pointSize,
                                                                 weight: .regular)
        timeRemainingLabel.font = UIFont.monospacedDigitSystemFont(ofSize: timeRemainingLabel.font.pointSize,
                                                                   weight: .regular)
        updateViews()
    }
    
    //MARK: - Actions
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
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let newRecordingTitle = titleTextField.text,
            !newRecordingTitle.isEmpty,
            let recording = recordingURL else { return }
        delegate.experienceWasAdded(experience: Experience(name: newRecordingTitle,
                                                           url: recording))
        navigationController?.popToRootViewController(animated: true)
    }
    
    //MARK: - Methods
    func updateViews() {
        guard isViewLoaded else { return }
        playButton.isEnabled = !isRecording
        recordButton.isEnabled = !isPlaying
        timeSlider.isEnabled = !isRecording
        
        playButton.isSelected = isPlaying
        recordButton.isSelected = isRecording
        titleTextField.text = experience?.title
        
        if !isRecording {
            let elapsedTime = audioPlayer?.currentTime ?? 0
            let duration = audioPlayer?.duration ?? 0
            let timeRemaining = duration.rounded() - elapsedTime
            
            timeElapsedLabel.text = timeIntervalFormatter.string(for: elapsedTime)
            
            timeSlider.minimumValue = 0
            timeSlider.maximumValue = Float(duration)
            timeSlider.value = Float(elapsedTime)
            
            timeRemainingLabel.text = "-" + timeIntervalFormatter.string(from: timeRemaining)!
        } else {
            let elapsedtime = audioRecorder?.currentTime ?? 0
            
            timeSlider.minimumValue = 0
            timeSlider.maximumValue = 1
            timeSlider.value = 0
            
            timeElapsedLabel.text = "--:--"
            timeRemainingLabel.text = timeIntervalFormatter.string(from: elapsedtime)
        }
    }
    
    deinit {
        timer?.invalidate()
    }
    
    // Timer
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
    
    // Playback
    
    var isPlaying: Bool {
        audioPlayer?.isPlaying ?? false
    }
    
    func loadAudio() {
        let songURL = Bundle.main.url(forResource: "piano", withExtension: "mp3")!
        if let experience = experience {
            audioPlayer = try? AVAudioPlayer(contentsOf: experience.url)
            return
        }
        audioPlayer = try? AVAudioPlayer(contentsOf: songURL)
        
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
    
    // Recording
    var isRecording: Bool {
        audioRecorder?.isRecording ?? false
    }
    
    func createNewRecordingURL() -> URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let name = ISO8601DateFormatter.string(from: Date(), timeZone: .current, formatOptions: .withInternetDateTime)
        let file = documents.appendingPathComponent(name, isDirectory: false).appendingPathExtension("caf")
        // caf- Core Audio Folder
        
        //        print("recording URL: \(file)")
        
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
        
        let recordingURL = createNewRecordingURL()
        
        let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1)!
        
        do {
            audioRecorder = try AVAudioRecorder(url: recordingURL, format: format)
            audioRecorder?.delegate = self
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.record()
            self.recordingURL = recordingURL
            updateViews()
            startTimer()
        } catch {
            preconditionFailure("The audio recorder could not be created with \(recordingURL) and \(format)")
        }
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        updateViews()
        cancelTimer()
    }
}


extension RecordingViewController: AVAudioPlayerDelegate {
    
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


extension RecordingViewController: AVAudioRecorderDelegate {
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
