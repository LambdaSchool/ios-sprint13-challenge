//
//  AudioViewController.swift
//  ExperinceJournal
//
//  Created by Lambda_School_Loaner_218 on 2/14/20.
//  Copyright © 2020 Lambda_School_Loaner_218. All rights reserved.
//

import UIKit
import AVFoundation

protocol AudioViewControllerDelegate {
    func audioPostButtonWasTapped()
}

class AudioViewController: UIViewController {

    var entryController: EntryController?
    let audioPlayerController = AudioPlayerController()
    let audioRecorderController = AudioRecorderController()
    var audioData: Data?
    var delegate: AudioViewControllerDelegate?

    @IBOutlet weak var recordingAudioButton: UIButton!
    @IBOutlet weak var playbackAudioButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeRemainingLabel: UILabel!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var postButton: UIBarButtonItem!

    private lazy var timeFormatter: DateComponentsFormatter = {
        let formatting = DateComponentsFormatter()
        formatting.unitsStyle = .positional 
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
        guard let recordURL = audioRecorderController.recordURL else { return }
        do {
            audioData = try Data(contentsOf: recordURL)
            audioPlayerController.loadAudio(url: recordURL)
            audioPlayerController.audioPlayer?.delegate = self
            postButton.isEnabled = true
            postButton.tintColor = UIColor.link
        } catch {
            print("Cant create audio data")
            return
        }
        audioPlayerController.playPause()
    }

    private func postAudio() {
        view.endEditing(true)
//TODO: check if user wants to geotag
      
        let title = "Audio Post"
        EntryController.shared.createPost(with: title, ofType: .audio, location: nil)
        delegate?.audioPostButtonWasTapped()
        dismiss(animated: true, completion: nil)
    }

    @IBAction func playbackAudioTapped(_ sender: UIButton) {
        playbackAudioRecording()
        updateViews()
    }

    @IBAction func recordAudioTapped(_ sender: UIButton) {
        audioRecorderController.recordToggle()
        updateViews()
    }

    @IBAction func postButtonTapped(_ sender: Any) {
        postAudio()
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
