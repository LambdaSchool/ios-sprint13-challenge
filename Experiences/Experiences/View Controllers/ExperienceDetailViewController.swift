//
//  ExperienceDetailViewController.swift
//  Experiences
//
//  Created by brian vilchez on 2/17/20.
//  Copyright © 2020 brian vilchez. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class ExperienceDetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var timeRemainingLabel: UILabel!
    @IBOutlet weak var timePlayedLabel: UILabel!
    @IBOutlet weak var pickedImage: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    
    var timer: Timer?
    var audioPlayer: AVAudioPlayer?
    private lazy var timeIntervalFormatter: DateComponentsFormatter = {
        let formatting = DateComponentsFormatter()
        formatting.unitsStyle = .positional
        formatting.zeroFormattingBehavior = .pad
        formatting.allowedUnits = [.minute, .second]
        return formatting
    }()
    
    var experience: Experience? {
        didSet {
            updateViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        timeSlider.value = 0
    }
    

    private func updateViews() {
        guard isViewLoaded else { return }
        guard let experience = experience else { return }
        titleLabel.text = experience.name
        pickedImage.image = experience.image
    }
    
    private func configureAudioPlayer() {
        playButton.isSelected = isPlaying
              let elapsedTime = audioPlayer?.currentTime ?? 0
              timeRemainingLabel.text = timeIntervalFormatter.string(from: elapsedTime)
              timeSlider.value = Float(elapsedTime)
              timeSlider.minimumValue = 0
              timeSlider.maximumValue = Float(audioPlayer?.duration ?? 0)
              let timeRemaining = (audioPlayer?.duration ?? 0) - elapsedTime
              timeRemainingLabel.text = timeIntervalFormatter.string(from: timeRemaining)
        
    }
    
    @IBAction func playRecording(_ sender: Any) {
        guard let audioURL = experience?.audioRecording else { return }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioURL )
        }catch {
            NSLog("failed to load file:")
        }
        playPause()
    }
    
    @IBAction func playVideoRecording(_ sender: Any) {
        guard let videoURL = experience?.videoRecording else { return }
            let player =  AVPlayer(url: videoURL)
            let videoPlayer = AVPlayerViewController()
            videoPlayer.player = player
        self.present(videoPlayer, animated: true) {
           // videoPlayer.player?.play()
        }
    }
    
    // helper Methods
    func startTimer() {
           stopTimer()
           timer = Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true, block: { [weak self] (timer) in
               guard let self = self else { return }
               self.configureAudioPlayer()
           })
       }

       func stopTimer() {
             timer?.invalidate()
             timer = nil
         }

         var isPlaying: Bool {
             audioPlayer?.isPlaying ?? false
         }

         func play() {
             audioPlayer?.play()
             startTimer()
             configureAudioPlayer()
         }

         func pause() {
             audioPlayer?.pause()
             stopTimer()
             configureAudioPlayer()
         }

         func playPause() {
             if isPlaying {
                 pause()
             } else {
                 play()
             }
         }
    
}
