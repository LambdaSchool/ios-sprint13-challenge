//
//  AudioDetailViewController.swift
//  MapNotes
//
//  Created by Thomas Sabino-Benowitz on 7/10/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import AVFoundation
import CoreLocation
import MapKit

class AudioDetailViewController: UIViewController {
    
    var audioPlayer: AVAudioPlayer? {
        didSet {
            
            guard let audioPlayer = audioPlayer else { return }
            audioPlayer.delegate = self
        }
    }
    var mapNoteController: MapNoteController?
    var coordinates: CLLocationCoordinate2D!
    var audioRecorder: AVAudioRecorder?
    //    This will point to the place that we record the audio, so we can play it back later
    var recordingURL: URL?
    
    var isPlaying: Bool {
        audioPlayer?.isPlaying ?? false
    }
   
    weak var timer: Timer?
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var timeElapsedLabel: UILabel!
    @IBOutlet weak var timeRemainingLabel: UILabel!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var audioVisualizer: AudioVisualizer!
    
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
        
        
        
        // Use a font that won't jump around as values change
        timeElapsedLabel.font = UIFont.monospacedDigitSystemFont(ofSize: timeElapsedLabel.font.pointSize,
                                                                 weight: .regular)
        timeRemainingLabel.font = UIFont.monospacedDigitSystemFont(ofSize: timeRemainingLabel.font.pointSize,
                                                                   weight: .regular)
        
        //        calling functions
        updateViews()
        
    }
    
    deinit {
        stopTimer()
    }
    
    private func updateViews() {
        //isPlaying
        playButton.isSelected = isPlaying
        recordButton.isSelected = isRecording
        //update time (currentTime)
        
        playButton.isEnabled = !isRecording
        recordButton.isEnabled = !isPlaying
        timeSlider.isEnabled = !isRecording
        
        let elapsedTime = audioPlayer?.currentTime ?? 0
        let elapsedTimeString =  timeIntervalFormatter.string(from: elapsedTime)
        timeElapsedLabel.text = elapsedTimeString
        
        let duration = audioPlayer?.duration ?? 0
        
        timeSlider.value = Float(elapsedTime)
        timeSlider.minimumValue = 0
        timeSlider.maximumValue = Float(duration)
        
        
        
        let timeRemaining = duration - elapsedTime
        let timeRemainingString = "-" + timeIntervalFormatter.string(from: timeRemaining)!
        timeRemainingLabel.text = timeRemainingString
        
        //         ToDo: Deal with time rounding up/down between both time labels
    }
    
    
    // MARK: - Playback
    
//    func loadAudio() {
//        // app bundle is raeadonly folder
//
//        let songURL = Bundle.main.url(forResource: "piano", withExtension: "mp3")! // programmer error if this fails to load
//
//        audioPlayer = try? AVAudioPlayer(contentsOf: songURL) // Fix better error handling
//        audioPlayer?.isMeteringEnabled = true
//        audioPlayer?.delegate = self
//
//    }
    
    //what do we want to do?
    //    pause, volume control, restart audio, update the time/labels
    
    func startTimer() {
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true, block: { [weak self] (timer) in
            guard let self = self else {return}
            
            self.updateViews()
            
            if let audioPlayer = self.audioPlayer {
                
                self.audioPlayer?.updateMeters()
                self.audioVisualizer.addValue(decibelValue: audioPlayer.averagePower(forChannel: 0))
                
            }
            
            if let audioRecorder = self.audioRecorder {
                print("working")
                audioRecorder.updateMeters()
                self.audioVisualizer.addValue(decibelValue: audioRecorder.averagePower(forChannel: 0))
            }
            
        })
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    
    func play() {
        audioPlayer?.play()
        startTimer()
        updateViews()
    }
    
    func pause() {
        audioPlayer?.pause()
        stopTimer()
        updateViews()
    }
    
    //    MARK: - playPause func
    func playPause() {
        if isPlaying {
            pause()
        } else {
            play()
        }
    }
    
    // MARK: - Recording
    
    var isRecording: Bool {
        audioRecorder?.isRecording ?? false
    }
    
    func startRecording() {
        recordingURL = makeNewRecordingURL()
        if let recordingURL = recordingURL {
            print("URL: \(recordingURL)")
            
            //44.1khz = FMQuality audio
            let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1)! // FixMe: Can Fail
            
            audioRecorder = try! AVAudioRecorder(url: recordingURL, format: format)
            audioRecorder?.record()
            audioRecorder?.delegate = self
            audioRecorder?.isMeteringEnabled = true
            updateViews()
            startTimer()
            
        }

    }
    
    func stopRecording(){
        audioRecorder?.stop()
        audioRecorder = nil
        updateViews()
        stopTimer()
    }
    
    func toggleRecording(){
        if isRecording {
            stopRecording()
        } else {
            startRecording()
        }
    }
    
    func makeNewRecordingURL() -> URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let name = ISO8601DateFormatter.string(from: Date(), timeZone: .current, formatOptions: [.withInternetDateTime])
        let url = documents.appendingPathComponent(name).appendingPathExtension("caf")
        return url
    }
    // MARK: - Actions
    
    @IBAction func togglePlayback(_ sender: Any) {
        playPause()
        
    }
    
    @IBAction func updateCurrentTime(_ sender: UISlider) {
        if isPlaying {
            pause()
        }
        
        audioPlayer?.currentTime = TimeInterval(sender.value)
        updateViews()
    }
    
    @IBAction func toggleRecording(_ sender: Any) {
        toggleRecording()
    }
    
    @IBAction func saveTapped( _sender: Any) {
        mapNoteController?.createMapNote(title: "Audio MapNote", coordinate: coordinates, audioURL: recordingURL)
        navigationController?.popToRootViewController(animated: true)
        
    }
}

extension AudioDetailViewController: AVAudioPlayerDelegate {
    
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        DispatchQueue.main.async {
            self.updateViews()
            self.stopTimer()
        }
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let error = error {
            print("AudioPlayer Error: \(error)")
        }
    }
}

extension AudioDetailViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag == true {
            // update player to load the new file
            if let recordingURL = recordingURL {
                audioPlayer = try? AVAudioPlayer(contentsOf: recordingURL)
                self.recordingURL = nil
                
                DispatchQueue.main.async {
                    self.updateViews()
                }
            }
        }
    }
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let error = error {
            NSLog("AudioRecorder error: \(error)")
        }
    }
}
