//
//  ExperienceAudioPlayerViewController.swift
//  Experiences
//
//  Created by Lambda_School_Loaner_268 on 5/8/20.
//  Copyright © 2020 Lambda. All rights reserved.
//

import UIKit
import AVFoundation
class ExperienceAudioPlayerViewController: UIViewController,  AVAudioPlayerDelegate{
    
    var pin: MapPin?
    @IBOutlet var timeElapsedLabel: UILabel!
       @IBOutlet var timeRemainingLabel: UILabel!
       @IBOutlet var timeSlider: UISlider!
       @IBOutlet var audioVisualizer: AudioVisualizer!
        @IBOutlet var playButton: UIButton!
    
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
              audioPlayer?.currentTime = TimeInterval(timeSlider.value)
              updateViews()
              
          }

    private lazy var timeIntervalFormatter: DateComponentsFormatter = {
        // NOTE: DateComponentFormatter is good for minutes/hours/seconds
        // DateComponentsFormatter is not good for milliseconds, use DateFormatter instead)
        
        let formatting = DateComponentsFormatter()
        formatting.unitsStyle = .positional // 00:00  mm:ss
        formatting.zeroFormattingBehavior = .pad
        formatting.allowedUnits = [.minute, .second]
        return formatting
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use a font that won't jump around as values change
        timeElapsedLabel.font = UIFont.monospacedDigitSystemFont(ofSize: timeElapsedLabel.font.pointSize,
                                                          weight: .regular)
        timeRemainingLabel.font = UIFont.monospacedDigitSystemFont(ofSize: timeRemainingLabel.font.pointSize,
                                                                   weight: .regular)
        
        loadAudio()
        updateViews()
        
        try? prepareAudioSession()
    }
    deinit {
         cancelTimer()
    }
    
     func updateViews() {
           playButton.isSelected = isPlaying
           let currentTime = audioPlayer?.currentTime ?? 0.0
           let duration = audioPlayer?.duration ?? 0.0
           // Rounding the duration prevents a glitch with labels updating at different times
           // 3.1 = currentTime -> 3
           // 7 = duration
           // 3.7 = timeRemaining -> 4
           let timeRemaining = round(duration) - currentTime
           timeElapsedLabel.text = timeIntervalFormatter.string(from: currentTime) ?? "00:00"
           timeRemainingLabel.text = "-" + (timeIntervalFormatter.string(from: timeRemaining) ?? "00:00")
           timeSlider.minimumValue = 0
           timeSlider.maximumValue = Float(duration)
           timeSlider.value = Float(currentTime)
    }
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
    
    var audioPlayer: AVAudioPlayer? {
            didSet {
                audioPlayer?.delegate = self
            }
        }
        var isPlaying: Bool {
            audioPlayer?.isPlaying ?? false
        }
        
        func loadAudio() {
            let songURL = ExperienceController.shared.audioURL
            
            audioPlayer = try? AVAudioPlayer(contentsOf: songURL!)
            
    }
        
        
        func prepareAudioSession() throws {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playAndRecord, options: [.defaultToSpeaker])
            try session.setActive(true, options: [])
            // can fail if on a phone call, for instance
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
        
      
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


