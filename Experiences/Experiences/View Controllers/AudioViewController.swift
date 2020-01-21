//
//  AudioViewController.swift
//  Experiences
//
//  Created by Brandi Bailey on 1/17/20.
//  Copyright © 2020 Brandi Bailey. All rights reserved.
//

import UIKit
import MapKit
import AVFoundation
import CoreData

class AudioViewController: UIViewController {
    
    var experienceLocation: CLLocation?
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeRemainingLabel: UILabel!
    @IBOutlet weak var titleLabel: UITextField!
    
    private lazy var timeFormatter: DateComponentsFormatter = {
        let formatting = DateComponentsFormatter()
        formatting.unitsStyle = .positional
        formatting.zeroFormattingBehavior = .pad
        formatting.allowedUnits = [.minute, .second]
        return formatting
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        timeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: timeLabel.font.pointSize,
                                                          weight: .regular)
        timeRemainingLabel.font = UIFont.monospacedDigitSystemFont(ofSize: timeRemainingLabel.font.pointSize,
                                                                   weight: .regular)
        updateViews()
    }
    
    var audioPlayer: AVAudioPlayer?
    var timer: Timer?
    
    var isPlaying: Bool {
        audioPlayer?.isPlaying ?? false
    }
    
    func play() {
        audioPlayer?.play()
        updateViews()
        startTimer()
    }
    
    func pause() {
        audioPlayer?.pause()
        updateViews()
        cancelTimer()
    }
    
    func playPause() {
        if isPlaying {
            pause()
        } else {
            play()
        }
    }
    
    private func startTimer() {
        cancelTimer() // to make sure only one timer is running and no others
        timer = Timer.scheduledTimer(timeInterval: 0.03, target: self, selector: #selector(updateTimer(timer:)), userInfo: nil, repeats: true)
    }
    
    @objc private func updateTimer(timer: Timer) {
        updateViews()
    }
    
    private func cancelTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func loadAudio() {
        
        let songURL = Bundle.main.url(forResource: "piano", withExtension: "mp3")!
        
        audioPlayer = try! AVAudioPlayer(contentsOf: songURL)  // FIXME: catch error and print
        audioPlayer?.delegate = self
    }
    
    @IBAction func playPressed(_ sender: Any) {
        playPause()
    }
    
    var audioRecorder: AVAudioRecorder?
    var recordURL: URL?
    
    var isRecording: Bool {
        return audioRecorder?.isRecording ?? false
    }
    
    func record() {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let name = ISO8601DateFormatter.string(from: Date(), timeZone: .current, formatOptions: [.withInternetDateTime])
        let file = documents.appendingPathComponent(name).appendingPathExtension("caf")
        recordURL = file
        
        print("record: \(file)")
        
        // 44.1 KHz 44,100 samples per second, 1 microphone
        let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1)! // FIXME: error handling
        
        audioRecorder = try! AVAudioRecorder(url: file, format: format) // FIXME: try!
        audioRecorder?.delegate = self
        audioRecorder?.record()
        updateViews()
    }
    
    func stop() {
        audioRecorder?.stop()
        audioRecorder = nil
        updateViews()
    }
    
    func recordToggle() {
        if isRecording {
            stop()
        } else {
            record()
        }
    }
    
    
    @IBAction func recordTapped(_ sender: Any) {
        recordToggle()
        updateViews()
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        saveAudioToCoreData()
        
        
    }
    
    
    func saveAudioToCoreData() {
        let experience = Experience(context: CoreDataStack.context)
        
        guard let experienceLocation = self.experienceLocation else { return }
        
        let latitude = Double(experienceLocation.coordinate.latitude)
        let longitude = Double(experienceLocation.coordinate.longitude)
        
        
        experience.title = titleLabel.text
        experience.latitude = latitude
        experience.longitude = longitude
        experience.mediaURL = recordURL
        experience.mediaType = ".caf"
        experience.date = Date.currentTimeStamp
        
        print(self.recordURL)
        
        CoreDataStack.saveContext()
        
                self.navigationController?.popToRootViewController(animated: true)
    }
    
    // Update UI
    
    private func updateViews() {
        
        let playButtonTitle = isPlaying ? "Pause" : "Play"
        playButton.setTitle(playButtonTitle, for: .normal)
        
        let elapsedTime = audioPlayer?.currentTime ?? 0
        timeLabel.text = timeFormatter.string(from: elapsedTime)
        
        // reset the slider - per asset, ex: per different audio file
        
        timeSlider.minimumValue = 0
        timeSlider.maximumValue = Float(audioPlayer?.duration ?? 0)
        timeSlider.value = Float(elapsedTime)
        
        let recordButtonTitle = isRecording ? "Stop" : "Record"
        recordButton.setTitle(recordButtonTitle, for: .normal)
        
        timeRemainingLabel.text = timeFormatter.string(from: (audioPlayer?.duration ?? 0) - elapsedTime)
    }
}

extension AudioViewController: AVAudioPlayerDelegate {
    
    // Resets when it's finished playing
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
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let error = error {
            print("Audio Player error: \(error)")
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        print("Finished Recording")
        
        if let recordURL = recordURL {
            audioPlayer = try! AVAudioPlayer(contentsOf: recordURL)
            updateViews()
        }
    }
}

extension AudioViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        titleLabel.resignFirstResponder()
        
        return true
    }
}



