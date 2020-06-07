//
//  ExperiencesTableViewCell.swift
//  Experiences
//
//  Created by Bradley Diroff on 6/6/20.
//  Copyright © 2020 Bradley Diroff. All rights reserved.
//

import UIKit
import AVFoundation

class ExperiencesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var audioVisualizer: AudioVisualizer!
    @IBOutlet weak var timeElapsedLabel: UILabel!
    @IBOutlet weak var timeRemainingLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var messageText: UILabel!
    @IBOutlet weak var audioView: UIView!
    @IBOutlet weak var pictureView: UIImageView!
    
    @IBAction func didPressPlay(_ sender: Any) {
        if isPlaying {
            pause()
        } else {
            play()
        }
    }
    
    @IBAction func updateTime(_ sender: UISlider) {
        if isPlaying {
            pause()
        }
        
        audioPlayer?.currentTime = TimeInterval(timeSlider.value)
        updateViews()
    }
    
    var experience: Experience? {
        didSet {
            startTheCell()
        }
    }
    
    private lazy var timeIntervalFormatter: DateComponentsFormatter = {
        
        let formatting = DateComponentsFormatter()
        formatting.unitsStyle = .positional
        formatting.zeroFormattingBehavior = .pad
        formatting.allowedUnits = [.minute, .second]
        return formatting
    }()
    
    func startTheCell() {
        
        let message = experience?.message ?? "No message"
        
        timeElapsedLabel.font = UIFont.monospacedDigitSystemFont(ofSize: timeElapsedLabel.font.pointSize,
                                                                 weight: .regular)
        timeRemainingLabel.font = UIFont.monospacedDigitSystemFont(ofSize: timeRemainingLabel.font.pointSize,
                                                                   weight: .regular)
        
        messageText.text = message
        
        if let picture = experience?.picture {
            pictureView.image = picture
        }
        
        loadAudio()
        updateViews()
        try? prepareAudioSession()
    }
    
    private func updateViews() {
        playButton.isSelected = isPlaying
        
        let currentTime = audioPlayer?.currentTime ?? 0.0
        let duration = audioPlayer?.duration ?? 0.0
        
        let timeRemaining = round(duration) - currentTime
        
        timeElapsedLabel.text = timeIntervalFormatter.string(from: currentTime) ?? "00:00"
        timeRemainingLabel.text = "-" + (timeIntervalFormatter.string(from: timeRemaining) ?? "00:00")
        
        timeSlider.minimumValue = 0
        timeSlider.maximumValue = Float(duration)
        timeSlider.value = Float(currentTime)
        
    }
    
    // MARK: - Timer
    
    var timer: Timer?
    
    func startTimer() {
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.030, repeats: true) { [weak self] (_) in
            guard let self = self else { return }
            
            self.updateViews()
            
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
    
    // MARK: - Playback
    
    var audioPlayer: AVAudioPlayer? {
        didSet {
            audioPlayer?.delegate = self
            audioPlayer?.isMeteringEnabled = true
        }
    }
    
    var isPlaying: Bool {
        audioPlayer?.isPlaying ?? false
    }
    
    func loadAudio() {
        guard let experience = experience, let audio = experience.audio else {return}
        audioPlayer = try? AVAudioPlayer(contentsOf: audio)
    }
    
    func prepareAudioSession() throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playAndRecord, options: [.defaultToSpeaker])
        try session.setActive(true, options: [])
    }
    
    func play() {
        audioPlayer?.play()
        startTimer()
        updateViews()
    }
    
    func pause() {
        audioPlayer?.pause()
        cancelTimer()
        updateViews()
    }
    
}

extension ExperiencesTableViewCell: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        updateViews()
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let error = error {
            print("Audio Player Error: \(error)")
        }
        updateViews()
    }
}

