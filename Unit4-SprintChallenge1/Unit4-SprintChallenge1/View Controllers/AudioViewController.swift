//
//  AudioViewController.swift
//  Unit4-SprintChallenge1
//
//  Created by Lambda_School_Loaner_204 on 1/16/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class AudioViewController: UIViewController {

    var entryController: EntryController?
    let audioPlayerController = AudioPlayerController()
    let audioRecorderController = AudioRecorderController()

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
        let playButtonTitle = audioPlayerController.isPlaying ? "Pause" : "Playback Recording"
        playbackAudioButton.setTitle(playButtonTitle, for: .normal)

        let elapsedTime = audioPlayerController.audioPlayer?.currentTime ?? 0
        let duration = audioPlayerController.audioPlayer?.duration ?? 0
        timeLabel.text = timeFormatter.string(from: elapsedTime)

        timeSlider.minimumValue = 0
        timeSlider.maximumValue = Float(duration)
        timeSlider.value = Float(elapsedTime)

        let recordButtonTitle = audioRecorderController.isRecording ? "Stop" : "Start Recording"
        recordingAudioButton.setTitle(recordButtonTitle, for: .normal)

        let timeRemaining = duration - elapsedTime
        timeRemainingLabel.text = timeFormatter.string(from: timeRemaining)
    }

    func playbackAudioRecording() {
        if let recordURL = audioRecorderController.recordURL {
            audioPlayerController.loadAudio(url: recordURL)
        } else {
            return
        }
        audioPlayerController.playPause()
    }

    @IBAction func playbackAudioTapped(_ sender: UIButton) {
        playbackAudioRecording()
        updateViews()
    }

    @IBAction func recordAudioTapped(_ sender: UIButton) {
        audioRecorderController.recordToggle()
        updateViews()
    }


    // TODO Implement posting
    @IBAction func postButtonTapped(_ sender: Any) {

    }

    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    
    
}
