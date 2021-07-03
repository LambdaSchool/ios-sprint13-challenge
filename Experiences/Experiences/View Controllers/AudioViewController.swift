//
//  AudioViewController.swift
//  Experiences
//
//  Created by Keri Levesque on 4/10/20.
//  Copyright © 2020 Keri Levesque. All rights reserved.
//

import UIKit
import AVFoundation

class AudioViewController: UIViewController {

    //MARK: Properties
    var media: Media?
    var delegate: ExperienceTableViewControllerDelegate?
    private var player: Player? = nil
    
    private var recorder: Recorder? = nil
    private lazy var timeFormatter: DateComponentsFormatter = {
        let formatting = DateComponentsFormatter()
        formatting.unitsStyle = .positional
        formatting.zeroFormattingBehavior = .pad
        formatting.allowedUnits = [.minute, .second]
        return formatting
      }()
      
    
    //MARK: Outlets
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var timeRemainingLabel: UILabel!
    
  
    //MARK: - View Lifecycle
    
    required init?(coder: NSCoder) {
          super.init(coder: coder)
      }
      
    override func viewDidLoad() {
          super.viewDidLoad()
          if let media = media,
              let url = media.mediaURL {
              player = Player(url: url)
          }
          recorder = Recorder()
          player?.delegate = self
          recorder?.delegate = self
          timeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: timeLabel.font.pointSize, weight: .regular)
          timeRemainingLabel.font = UIFont.monospacedDigitSystemFont(ofSize: timeRemainingLabel.font.pointSize, weight: .regular)
          recordButton.tintColor = .systemTeal
          updateViews()
      }
      
    override func viewWillDisappear(_ animated: Bool) {
          if player?.isPlaying ?? false {
              player?.pause()
          }
          super.viewWillDisappear(animated)
      }
    //MARK: Actions
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        if let media = media,
            let player = player {
            if media.mediaURL != player.url {
                media.mediaURL = player.url
            }
        } else {
            if let player = player {
                let newMedia = Media(mediaType: .audio, url: player.url)
                delegate?.mediaAdded(media: newMedia)
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func recordButtonTapped(_ sender: Any) {
        player?.playPause()
    }
    
    @IBAction func pauseButtonTapped(_ sender: Any) {
        recorder?.toggleRecording()
        updateViews()
    }
    
    //MARK: - Private Methods
    private func updateViews() {
        let playTitle = player?.isPlaying ?? false ? "Pause" : "Play"
        recordButton.setTitle(playTitle, for: .normal)
        let recordTitle = recorder?.isRecording ?? false ? "Stop" : "Record"
        pauseButton.setTitle(recordTitle, for: .normal)
        if let player = player {
            recordButton.isHidden = false
            timeLabel.text = timeFormatter.string(from: player.timeElspsed)
            timeRemainingLabel.text = timeFormatter.string(from: player.timeRemaining)
               
            timeSlider.minimumValue = 0
            timeSlider.value = Float(player.timeElspsed)
            timeSlider.maximumValue = Float(player.duration)
           } else {
               recordButton.isHidden = true
           }
           if let recorder = recorder {
              if recorder.isRecording {
                   pauseButton.tintColor = .red
               } else {
                   pauseButton.tintColor = .systemTeal
               }
           }
       }
    
}
   //MARK: - Extensions
extension AudioViewController: PlayerDelegate {
    func playDidChangeState(player: Player) {
        updateViews()
    }
}

extension AudioViewController: RecorderDelegate {
    func recorderDidChangeState(recorder: Recorder) {
        updateViews()
    }
    
func recorderDidSaveFile(recorder: Recorder) {
    if let url = recorder.fileURL, !recorder.isRecording {
        player = Player(url: url)
        player?.delegate = self
        updateViews()
        player?.play()
        
    }
    
    }
}
