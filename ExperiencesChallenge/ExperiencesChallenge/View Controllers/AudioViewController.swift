//
//  AudioViewController.swift
//  ExperiencesChallenge
//
//  Created by Ian French on 9/13/20.
//  Copyright © 2020 Ian French. All rights reserved.
//


import UIKit
import AVFoundation

protocol AudioViewControllerDelegate {
    func saveAudioButtonTapped()
}

class AudioViewController: UIViewController {

    var experienceController: ExperienceController?
    
    let audioPlayerController = AudioPlayerController()
    let audioRecorderController = AudioRecorderController()
    var audioData: Data?
    var delegate: AudioViewControllerDelegate?

    @IBOutlet weak var cancelButton: UIBarButtonItem!

    @IBOutlet weak var playbackRecordingButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeRemainingLabel: UILabel!
    @IBOutlet weak var timerSlider: UISlider!
    @IBOutlet weak var recordAudioButton: UIButton!
    @IBOutlet weak var saveAudioButton: UIButton!

    private lazy var timeIntervalFormatter: DateComponentsFormatter = {

        let formatting = DateComponentsFormatter()
        formatting.unitsStyle = .positional // 00:00  mm:ss
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

    private func updateViews() {
        let playButtonTitle = audioPlayerController.isPlaying ? "Pause" : "Playback Recording"
        playbackRecordingButton.setTitle(playButtonTitle, for: .normal)

        let elapsedTime = audioPlayerController.audioPlayer?.currentTime ?? 0
        let duration = audioPlayerController.audioPlayer?.duration ?? 0
        timeLabel.text = timeIntervalFormatter.string(from: elapsedTime)

        timerSlider.minimumValue = 0
        timerSlider.maximumValue = Float(duration)
        timerSlider.value = Float(elapsedTime)

        let recordButtonTitle = audioRecorderController.isRecording ? "Stop" : "Start Recording"
        recordAudioButton.setTitle(recordButtonTitle, for: .normal)

        let timeRemaining = duration - elapsedTime
        timeRemainingLabel.text = timeIntervalFormatter.string(from: timeRemaining)
    }

    func playbackAudioRecording() {
        guard let recordURL = audioRecorderController.recordingURL else { return }
        do {
            audioData = try Data(contentsOf: recordURL)
            audioPlayerController.loadAudio(url: recordURL)
            audioPlayerController.audioPlayer?.delegate = self
            saveAudioButton.isEnabled = true
            saveAudioButton.tintColor = UIColor.link
        } catch {
            print("Cannot create audio data")
            return
        }
        audioPlayerController.playPause()
    }

    private func addAudio() {
        view.endEditing(true)

        guard let _ = audioData else { return }
        let title = "Audio Entry"
        self.experienceController?.createPost(with: title, ofType: .audio, location: nil)
        delegate?.saveAudioButtonTapped()
        dismiss(animated: true, completion: nil)
    }


    @IBAction func recordAudioTapped(_ sender: Any) {
        audioRecorderController.recordToggle()
        updateViews()
    }

    @IBAction func saveAudioButtonTapped(_ sender: Any) {
        addAudio()
    }

    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func playbackRecordingTapped(_ sender: Any) {
        playbackAudioRecording()
        updateViews()
    }
}


extension AudioViewController: AVAudioPlayerDelegate {

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        updateViews()
        print("Audio file has finished playing")
    }

    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let error = error {
            print("Audio Player error: \(error)")
        }
    }
}
