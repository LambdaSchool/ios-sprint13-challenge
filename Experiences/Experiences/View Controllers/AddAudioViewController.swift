//
//  AddAudioViewController.swift
//  Experiences
//
//  Created by Cody Morley on 7/10/20.
//  Copyright © 2020 Cody Morley. All rights reserved.
//

import UIKit
import AVFoundation


class AddAudioViewController: UIViewController {
    //MARK: - Properties -
    @IBOutlet var recordButton: UIButton!
    @IBOutlet var playPauseButton: UIButton!
    @IBOutlet var stopButton: UIButton!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var timeElapsedLabel: UILabel!
    @IBOutlet var timeRemainingLabel: UILabel!
    @IBOutlet var timeSlider: UISlider!
    @IBOutlet var audioVisualizer: AudioVisualizer!
    
    var audioDelegate: AudioAdderDelegate?
    var recordingURL: URL?
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer? {
        didSet {
            guard let audioPlayer = audioPlayer else { return }
            audioPlayer.delegate = self
            audioPlayer.isMeteringEnabled = true
        }
    }
    var isPlaying: Bool {
        return audioPlayer?.isPlaying ?? false
    }
    var isRecording: Bool {
        audioRecorder?.isRecording ?? false
    }
    weak var timer: Timer?
    private lazy var timeIntervalFormatter: DateComponentsFormatter = {
        let formatting = DateComponentsFormatter()
        formatting.unitsStyle = .positional // 00:00  mm:ss
        formatting.zeroFormattingBehavior = .pad
        formatting.allowedUnits = [.minute, .second]
        return formatting
    }()
    
    
    //MARK: - Life Cycles -
    override func viewDidLoad() {
        super.viewDidLoad()
        timeElapsedLabel.font = UIFont.monospacedDigitSystemFont(ofSize: timeElapsedLabel.font.pointSize,
                                                                 weight: .regular)
        timeRemainingLabel.font = UIFont.monospacedDigitSystemFont(ofSize: timeRemainingLabel.font.pointSize,
                                                                   weight: .regular)
        updateViews()
    }
    
    //MARK: - Actions -
    @IBAction func togglePlayback(_ sender: Any) {
        if isPlaying {
            pause()
        } else {
            play()
        }
        updateViews()
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
            startRecording()
        }
        updateViews()
    }
    
    @IBAction func stopPlaybackOrRecord(_ sender: Any) {
        if isPlaying {
            audioPlayer?.stop()
        }
        if isRecording {
            audioRecorder?.stop()
            updateViews()
        }
        
    }
    
    @IBAction func saveRecordingToExperience() {
        if let url = recordingURL {
            audioDelegate?.addAudio(url)
        }
    }
    
    @IBAction func cancelPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    //MARK: - Methods -
    ///UI Methods
    func updateViews() {
        playPauseButton.isEnabled = !isRecording
        recordButton.isEnabled = !isPlaying
        timeSlider.isEnabled = !isRecording
        playPauseButton.isSelected = isPlaying
        recordButton.isSelected = isRecording
        if !isRecording {
            let elapsedTime = audioPlayer?.currentTime ?? 0
            let duration = audioPlayer?.duration ?? 0
            let timeRemaining = duration - elapsedTime
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
            timeRemainingLabel.text = "-" + timeIntervalFormatter.string(from: elapsedTime)!
        }
    }
    
    ///Recording methods
    func createNewRecordingURL() -> URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let name = ISO8601DateFormatter.string(from: Date(), timeZone: .current, formatOptions: .withInternetDateTime)
        let file = documents.appendingPathComponent(name, isDirectory: false).appendingPathExtension("caf")
        
        print("recording URL: \(file)")
        
        return file
    }
    
    func startRecording() {
        recordingURL = createNewRecordingURL() // Get url
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            guard granted else {
                NSLog("No Microphone access. Grant permisson to use recorder.") //Present alert here in production.
                return
            }
            guard let recordingURL = self.recordingURL else { return }
            let format = AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 1)!
            do {
                self.audioRecorder = try AVAudioRecorder(url: recordingURL, format: format)
                self.audioRecorder?.delegate = self
                self.audioRecorder?.isMeteringEnabled = true
                self.audioRecorder?.record()
                self.updateViews()
                self.startTimer()
            } catch {
                NSLog("Error setting up audio recorder: \(error) \(error.localizedDescription)")
                return
            }
        }
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        audioRecorder = nil
        updateViews()
    }
    
    ///Playback methods
    func play() {
        audioPlayer?.play()
        startTimer()
    }
    
    func pause() {
        audioPlayer?.pause()
        cancelTimer()
    }
    
    ///Timer Methods
    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.030, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            self.updateViews()
            
            if let audioRecorder = self.audioRecorder,
                self.isRecording == true {
                
                audioRecorder.updateMeters()
                self.audioVisualizer.addValue(decibelValue: audioRecorder.averagePower(forChannel: 0))
                
            }
            
            if let audioPlayer = self.audioPlayer,
                self.isPlaying == true {
                
                audioPlayer.updateMeters()
                self.audioVisualizer.addValue(decibelValue: audioPlayer.averagePower(forChannel: 0))
            }
        }
    }
    
    func cancelTimer() {
        timer?.invalidate()
        timer = nil
    }
}


extension AddAudioViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        DispatchQueue.main.async {
            self.updateViews()
        }
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let error = error {
            NSLog("Error decoding audio: Here's some info: \(error) \(error.localizedDescription)")
        }
    }
}


extension AddAudioViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if let recordingURL = recordingURL {
            audioPlayer = try? AVAudioPlayer(contentsOf: recordingURL)
            self.recordingURL = nil
            DispatchQueue.main.async {
                self.updateViews()
            }
        }
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let error = error {
            NSLog("Error recording audio: \(error) \(error.localizedDescription)")
        }
    }
}
