//
//  AudioViewController.swift
//  Truthly
//
//  Created by Ezra Black on 6/7/20.
//  Copyright © 2020 Casanova Studios. All rights reserved.
//

import UIKit
import AVFoundation

protocol AudioDelegate {
    func audioButtonTapped()
}

class AudioViewController: UIViewController {
    
    
    var delegate: AudioDelegate?
    var postController: PostController?
    let audioController = AudioController()
    let recordingController = RecordingController()
    var audioData: Data?

        @IBOutlet weak var recordingAudioButton: UIButton!
        @IBOutlet weak var playbackAudioButton: UIButton!
        @IBOutlet weak var timeLabel: UILabel!
        @IBOutlet weak var timeRemainingLabel: UILabel!
        @IBOutlet weak var timeSlider: UISlider!
        @IBOutlet weak var postButton: UIBarButtonItem!

        private lazy var timeFormatter: DateComponentsFormatter = {
            let formatting = DateComponentsFormatter()
            formatting.unitsStyle = .positional // 00:00  mm:ss
            // NOTE: DateComponentFormatter is good for minutes/hours/seconds
            // DateComponentsFormatter not good for milliseconds, use DateFormatter instead)
            formatting.zeroFormattingBehavior = .pad
            formatting.allowedUnits = [.minute, .second]
            return formatting
        }()

        override func viewDidLoad() {
            super.viewDidLoad()
            postButton.isEnabled = false
            postButton.tintColor = UIColor.gray

            timeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: timeLabel.font.pointSize,
                                                              weight: .regular)
            timeRemainingLabel.font = UIFont.monospacedDigitSystemFont(ofSize: timeRemainingLabel.font.pointSize,
                                                                       weight: .regular)

            updateViews()

        }

        private func updateViews() {
            let playButtonTitle = audioController.isPlaying ? "Pause" : "Playback Recording"
            playbackAudioButton.setTitle(playButtonTitle, for: .normal)

            let elapsedTime = audioController.audioPlayer?.currentTime ?? 0
            let duration = audioController.audioPlayer?.duration ?? 0
            timeLabel.text = timeFormatter.string(from: elapsedTime)

            timeSlider.minimumValue = 0
            timeSlider.maximumValue = Float(duration)
            timeSlider.value = Float(elapsedTime)

            let recordButtonTitle = recordingController.isRecording ? "Stop" : "Start Recording"
            recordingAudioButton.setTitle(recordButtonTitle, for: .normal)

            let timeRemaining = duration - elapsedTime
            timeRemainingLabel.text = timeFormatter.string(from: timeRemaining)
        }

        func playbackAudioRecording() {
            guard let recordURL = recordingController.recordURL else { return }
            do {
                audioData = try Data(contentsOf: recordURL)
                audioController.loadAudio(url: recordURL)
                audioController.audioPlayer?.delegate = self
                postButton.isEnabled = true
                postButton.tintColor = UIColor.link
            } catch {
                print("Cant create audio data")
                return
            }
            audioController.playPause()
        }

        private func postAudio() {
            view.endEditing(true)

            guard let _ = audioData else { return }
            let title = "Audio Post"
            self.postController?.createPost(with: title, ofType: .audio, location: nil)
            delegate?.audioButtonTapped()
            dismiss(animated: true, completion: nil)
        }

        @IBAction func playbackAudioTapped(_ sender: UIButton) {
            playbackAudioRecording()
            updateViews()
        }

        @IBAction func recordAudioTapped(_ sender: UIButton) {
            recordingController.recordToggle()
            updateViews()
        }

        @IBAction func postButtonTapped(_ sender: Any) {
            postAudio()
        }

        @IBAction func cancelButtonTapped(_ sender: Any) {
            dismiss(animated: true, completion: nil)
        }
    }


extension AudioViewController: AVAudioPlayerDelegate {
        
        func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
            updateViews()
            print("Finished Playing")
        }

        func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
            if let error = error {
                print("Audio Player error: \(error)")
            }
        }
    }
